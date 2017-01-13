//
//  Scene.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "Scene.h"

Scene::Scene(){
    
    initializeGPUData();
    
}

Scene::Scene(shared_ptr<ofTrueTypeFont> _mainFont){
    
    //Create the user interface
    
    interface = Interface(_mainFont);
    
    //Loade the image that will represend the button
    
    backButtonImg.load("images/back_button.png");
    
    //This keeps a reference to the button created so that we can change its settings.
    
    shared_ptr<Button> backButton = interface.addButton("SCENE-MENU", "SCENE-MENU", ofVec2f(0.0390625 * ofGetWidth()));
    backButton->setDimensions(ofVec2f(0.0390625 * ofGetWidth()));
    backButton->setImage(backButtonImg);
    
    //Create the actuator box, where the player can take the actuators
    //This is useful to detect whether the actuators are active or not.
    //The player can drag them from the box to make them become active.
    //Actuators activity is defined in the update function.
    
    actuatorBox.set(-1, -1, ofGetWidth() + 10, 0.05859375 * ofGetHeight());
    
    //Load all textures useful to render the differents objects of the game.
    
    actuatorImg.load("images/unactive_actuator.png");
    receptorImg.load("images/receptor.png");
    emitterImg.load("images/emitter.png");
    activeActuatorImg.load("images/actuator.png");
    particleImg.load("images/particleTex_1.png");
    actuatorArrowImg.load("images/actuator_arrow_2.png");
    polygoneImg.load("images/polygone_tex.png");
    dashedPolygoneImg.load("images/dashed_polygone.png");
    
    //Load the font that will be used to display informations on the scene
    
    infosFont.load("GT-Cinetype-Mono.ttf", 0.009765625 * ofGetWidth());
    
    //Sounds
    //Create an array of sounds that will be plaed when particles touch someting.
    
    for(int i = 0; i < 100; i++){
        
        ofSoundPlayer newSound;
        newSound.load("sounds/bell"+ to_string((int) ofRandom(1, 5)) +".mp3");
        particlesSounds.push_back(newSound);
        
    }
    
};

//This function is called once at the set up of the scene, at the end of the XMLSetup function.
//This takes care of allocating enough space for data used for rendering the scene.

void Scene::initializeGPUData(){
    
    //GPU Rendering
    //Load custom shaders and create the programs
    
    particleHeadProgram.load("shaders/particleHead");
    particleTailProgram.load("shaders/particleTail");
    polygoneProgram.load("shaders/polygoneShader");
    polygoneWireframeProgram.load("shaders/polygoneShaderWireframe");
    actuatorsProgram.load("shaders/actuatorShader");
    receptorProgram.load("shaders/receptorShader");
    quadTextureProgram.load("shaders/quadTextureShader");
    simpleQuadTextureProgram.load("shaders/simpleQuadTextureShader");
    dashedPolygoneProgram.load("shaders/dashedPolygoneShader");
    
    
    //HEADS.
    //Set un vbo for rendering the particles head.
    //We allocate the maximum space so we don't need to change it afterwards.
    
    positions = vector<ofVec3f>(MAX_PARTICLES, ofVec3f(0));
    attributes = vector<ofVec3f>(MAX_PARTICLES, ofVec3f(0));
    
    particlesHeadVbo.setVertexData(&positions[0], (int) positions.size(), GL_DYNAMIC_DRAW);
    particlesHeadVbo.setNormalData(&attributes[0], (int) attributes.size(), GL_STATIC_DRAW);
    
    //TAILS.
    //Set un vbo for rendering the particles tail.
    //MAX_TAIL_LENGTH is the max number of points composing the particle tail.
    
    tailPoints = vector<ofVec3f>(MAX_PARTICLES * MAX_TAIL_LENGTH, ofVec3f(0));
    tailColors = vector<ofFloatColor>(MAX_PARTICLES * MAX_TAIL_LENGTH, ofFloatColor(1.0, 1.0, 1.0, 0.0));
    
    //Create the indices that will tell the graphic card witch segments to draw.
    
    for(int i = 0; i < MAX_PARTICLES; i++){
        
        for(int j = 0; j < MAX_TAIL_LENGTH - 1; j++){
            
            tailIndices.push_back(i * MAX_TAIL_LENGTH + j);
            tailIndices.push_back(i * MAX_TAIL_LENGTH + j + 1);
            
        }
        
    }
    
    //Allocate all the date computed above in the particleTailVbo.
    
    particlesTailVbo.setVertexData(&tailPoints[0], (int) tailPoints.size(), GL_STREAM_DRAW);
    particlesTailVbo.setColorData(&tailColors[0], (int) tailColors.size(), GL_STREAM_DRAW);
    particlesTailVbo.setIndexData(&tailIndices[0], (int) tailIndices.size(), GL_STATIC_DRAW);
    
    //Update GPU data
    //Here we calculate and update the first time all the data that will be stored in the objects declared just before.
    
    updateParticlesRenderingData();
    
    //Here we update the container of all particles present in the scene to simplify rendering pipeline.
    
    updateAllParticles();
    
    //Emitters
    
    for(int i = 0; i < emitters.size(); i++){
        
        //Set vertices
        
        vector<ofVec3f> quadVertices = getQuadVertices(100 * 2);
        
        ofMatrix4x4 mat;
        mat.translate(emitters[i]->getPosition());
        
        for(int i = 0; i < quadVertices.size(); i++){
            
            quadVertices[i] = quadVertices[i] * mat;
            
        }
        
        emittersVertices.insert(emittersVertices.end(), quadVertices.begin(), quadVertices.end());
        
        //Set indices -> 6 indices to define a quad.
        
        //This is the first triangle
        
        emittersIndices.push_back(i * 4);
        emittersIndices.push_back(i * 4 + 1);
        emittersIndices.push_back(i * 4 + 3);
        
        //This is the second triangls
        
        emittersIndices.push_back(i * 4 + 1);
        emittersIndices.push_back(i * 4 + 2);
        emittersIndices.push_back(i * 4 + 3);
        
        //Set textures coordinates
        
        emittersTexCoords.push_back(ofVec2f(-1));
        emittersTexCoords.push_back(ofVec2f(1, -1));
        emittersTexCoords.push_back(ofVec2f(1));
        emittersTexCoords.push_back(ofVec2f(-1, 1));
        
    }
    
    emittersVbo.setVertexData(&emittersVertices[0], (int) emittersVertices.size(), GL_DYNAMIC_DRAW);
    emittersVbo.setIndexData(&emittersIndices[0], (int) emittersIndices.size(), GL_STATIC_DRAW);
    emittersVbo.setTexCoordData(&emittersTexCoords[0], (int) emittersTexCoords.size(), GL_STATIC_DRAW);
    
    //Actuators
    
    int currentRingVertexIndex = 0;
    
    for(int i = 0; i < actuators.size(); i++){
        
        //Set vertices
        
        vector<ofVec3f> quadVertices = getQuadVertices(50);
        
        ofMatrix4x4 mat;
        mat.translate(actuators[i]->getPosition());
        
        for(int i = 0; i < quadVertices.size(); i++){
            
            quadVertices[i] = quadVertices[i] * mat;
            
        }
        
        actuatorsVertices.insert(actuatorsVertices.end(), quadVertices.begin(), quadVertices.end());
        
        //Set indices -> 6 indices to define a quad.
        
        //This is the first triangle
        
        actuatorsIndices.push_back(i * 4);
        actuatorsIndices.push_back(i * 4 + 1);
        actuatorsIndices.push_back(i * 4 + 3);
        
        //This is the second triangls
        
        actuatorsIndices.push_back(i * 4 + 1);
        actuatorsIndices.push_back(i * 4 + 2);
        actuatorsIndices.push_back(i * 4 + 3);
        
        //Set textures coordinates
        
        actuatorsTexCoords.push_back(ofVec2f(-0.25));
        actuatorsTexCoords.push_back(ofVec2f(0.25, -0.25));
        actuatorsTexCoords.push_back(ofVec2f(0.25));
        actuatorsTexCoords.push_back(ofVec2f(-0.25, 0.25));
        
        //Set attributes send throw normal attribute for each vertex
        
        actuatorsAttributes.push_back(ofVec3f(50, 0.0, 0.0));
        actuatorsAttributes.push_back(ofVec3f(50, 0.0, 0.0));
        actuatorsAttributes.push_back(ofVec3f(50, 0.0, 0.0));
        actuatorsAttributes.push_back(ofVec3f(50, 0.0, 0.0));
        
        //Ring
        
        for(int j = 0; j < 8; j++){
            
            float angle = (float) (360.0 / 8.0) * j;
            
            vector<ofVec3f> quadVertices = getQuadVertices(36);
            
            ofMatrix4x4 mat;
            mat.glTranslate(actuators[i]->getPosition());
            mat.glRotate(angle, 0, 0, 1);
            mat.glTranslate(0, actuators[i]->getRadius(), 0);
            
            //Apply tranformation
            
            for(int k = 0; k < quadVertices.size(); k++){
                
                actuatorsRingVertices.push_back(quadVertices[k] * mat);
                
            }
            
            //Set indices -> 6 indices to define a quad.
            
            //This is the first triangle
            
            actuatorsRingIndices.push_back(currentRingVertexIndex);
            actuatorsRingIndices.push_back(currentRingVertexIndex + 1);
            actuatorsRingIndices.push_back(currentRingVertexIndex + 3);
            
            //This is the second triangls
            
            actuatorsRingIndices.push_back(currentRingVertexIndex + 1);
            actuatorsRingIndices.push_back(currentRingVertexIndex + 2);
            actuatorsRingIndices.push_back(currentRingVertexIndex + 3);
            
            //Set textures coordinates
            
            actuatorsRingTexCoords.push_back(ofVec2f(-1));
            actuatorsRingTexCoords.push_back(ofVec2f(1, -1));
            actuatorsRingTexCoords.push_back(ofVec2f(1));
            actuatorsRingTexCoords.push_back(ofVec2f(-1, 1));
            
            //Set colors
            
            actuatorsRingColors.push_back(ofFloatColor(1.0, 1.0, 1.0, getAlpha() / 255));
            actuatorsRingColors.push_back(ofFloatColor(1.0, 1.0, 1.0, getAlpha() / 255));
            actuatorsRingColors.push_back(ofFloatColor(1.0, 1.0, 1.0, getAlpha() / 255));
            actuatorsRingColors.push_back(ofFloatColor(1.0, 1.0, 1.0, getAlpha() / 255));
            
            currentRingVertexIndex += 4;
            
        }
        
    }
    
    actuatorsVbo.setVertexData(&actuatorsVertices[0], (int) actuatorsVertices.size(), GL_DYNAMIC_DRAW);
    actuatorsVbo.setNormalData(&actuatorsAttributes[0], (int) actuatorsAttributes.size(), GL_STATIC_DRAW);
    actuatorsVbo.setIndexData(&actuatorsIndices[0], (int) actuatorsIndices.size(), GL_STATIC_DRAW);
    actuatorsVbo.setTexCoordData(&actuatorsTexCoords[0], (int) actuatorsTexCoords.size(), GL_STATIC_DRAW);
    
    actuatorsRingVbo.setVertexData(&actuatorsRingVertices[0], (int) actuatorsRingVertices.size(), GL_DYNAMIC_DRAW);
    actuatorsRingVbo.setIndexData(&actuatorsRingIndices[0], (int) actuatorsRingIndices.size(), GL_STATIC_DRAW);
    actuatorsRingVbo.setTexCoordData(&actuatorsRingTexCoords[0], (int) actuatorsRingTexCoords.size(), GL_STATIC_DRAW);
    actuatorsRingVbo.setColorData(&actuatorsRingColors[0], (int) actuatorsRingColors.size(), GL_DYNAMIC_DRAW);
    
    //Receptors
    
    for(int i = 0; i < receptors.size(); i++){
        
        //Set vertices
        
        vector<ofVec3f> quadVertices = getQuadVertices(receptors[i]->getRadius() * 2);
        
        ofMatrix4x4 mat;
        mat.glTranslate(receptors[i]->getPosition());
        
        for(int i = 0; i < quadVertices.size(); i++){
            
            quadVertices[i] = quadVertices[i] * mat;
            
        }
        
        receptorsVertices.insert(receptorsVertices.end(), quadVertices.begin(), quadVertices.end());
        
        //Set indices -> 6 indices to define a quad.
        
        //This is the first triangle
        
        receptorsIndices.push_back(i * 4);
        receptorsIndices.push_back(i * 4 + 1);
        receptorsIndices.push_back(i * 4 + 3);
        
        //This is the second triangls
        
        receptorsIndices.push_back(i * 4 + 1);
        receptorsIndices.push_back(i * 4 + 2);
        receptorsIndices.push_back(i * 4 + 3);
        
        //Set textures coordinates
        
        receptorsTexCoords.push_back(ofVec2f(-1));
        receptorsTexCoords.push_back(ofVec2f(1, -1));
        receptorsTexCoords.push_back(ofVec2f(1));
        receptorsTexCoords.push_back(ofVec2f(-1, 1));
        
        //Set attributes send throw normal attribute for each vertex
        
        receptorsAttributes.push_back(ofVec3f(receptors[i]->getRadius(), 0.0, 0.0));
        receptorsAttributes.push_back(ofVec3f(receptors[i]->getRadius(), 0.0, 0.0));
        receptorsAttributes.push_back(ofVec3f(receptors[i]->getRadius(), 0.0, 0.0));
        receptorsAttributes.push_back(ofVec3f(receptors[i]->getRadius(), 0.0, 0.0));
        
    }
    
    receptorsVbo.setVertexData(&receptorsVertices[0], (int) receptorsVertices.size(), GL_DYNAMIC_DRAW);
    receptorsVbo.setNormalData(&receptorsAttributes[0], (int) receptorsAttributes.size(), GL_DYNAMIC_DRAW);
    receptorsVbo.setIndexData(&receptorsIndices[0], (int) receptorsIndices.size(), GL_STATIC_DRAW);
    receptorsVbo.setTexCoordData(&receptorsTexCoords[0], (int) receptorsTexCoords.size(), GL_STATIC_DRAW);
    
    //Polygones
    
    for(int i = 0; i < polygones.size(); i++){
        
        ofxTriangle triangles = polygones[i]->getTriangulatedPolygone();
        
        for(int j = 0; j < triangles.nTriangles; j++){
            
            ofVec3f p1 = ofVec3f(triangles.triangles[j].a.x, triangles.triangles[j].a.y, 0.0);
            ofVec3f p2 = ofVec3f(triangles.triangles[j].b.x, triangles.triangles[j].b.y, 0.0);
            ofVec3f p3 = ofVec3f(triangles.triangles[j].c.x, triangles.triangles[j].c.y, 0.0);
            
            polygonesVertices.push_back(p1);
            polygonesVertices.push_back(p2);
            polygonesVertices.push_back(p3);
            
            polygonesIndices.push_back(polygonesIndices.size());
            polygonesIndices.push_back(polygonesIndices.size());
            polygonesIndices.push_back(polygonesIndices.size());
            
            polygonesTexCoords.push_back(ofVec2f(0.5, 0));
            polygonesTexCoords.push_back(ofVec2f(1, 1));
            polygonesTexCoords.push_back(ofVec2f(0, 1));
            
            polygoneVerticesColor.push_back(ofFloatColor(1.0, 0.0, 0.0));
            polygoneVerticesColor.push_back(ofFloatColor(0.0, 1.0, 0.0));
            polygoneVerticesColor.push_back(ofFloatColor(0.0, 0.0, 1.0));
            
            float angle1 = (p1 - p2).angleRad(p1 - p3);
            float angle2 = (p2 - p3).angleRad(p2 - p1);
            float angle3 = (p3 - p2).angleRad(p3 - p1);
            
            float h1 = sin(angle2) * (p2 - p1).length();
            float h2 = sin(angle3) * (p3 - p2).length();
            float h3 = sin(angle1) * (p1 - p3).length();
            
            polygonesAttributes.push_back(ofVec3f(h1, h2, h3));
            polygonesAttributes.push_back(ofVec3f(h1, h2, h3));
            polygonesAttributes.push_back(ofVec3f(h1, h2, h3));
            
        }
        
    }
    
    polygonesVbo.setVertexData(&polygonesVertices[0], (int) polygonesVertices.size(), GL_STATIC_DRAW);
    polygonesVbo.setIndexData(&polygonesIndices[0], (int) polygonesIndices.size(), GL_STATIC_DRAW);
    polygonesVbo.setTexCoordData(&polygonesTexCoords[0], (int) polygonesTexCoords.size(), GL_STATIC_DRAW);
    polygonesVbo.setColorData(&polygoneVerticesColor[0], (int) polygoneVerticesColor.size(), GL_STATIC_DRAW);
    polygonesVbo.setNormalData(&polygonesAttributes[0], (int) polygonesAttributes.size(), GL_STATIC_DRAW);
    
//    //First test but cool for other project
    
//    for(int i = 0; i < polygones.size(); i++){
//        
//        ofxTriangle triangles = polygones[i]->getTriangulatedPolygone();
//        
//        for(int j = 0; j < triangles.nTriangles; j++){
//         
//            ofVec3f p1 = ofVec3f(triangles.triangles[j].a.x, triangles.triangles[j].a.y, 0.0);
//            ofVec3f p2 = ofVec3f(triangles.triangles[j].b.x, triangles.triangles[j].b.y, 0.0);
//            ofVec3f p3 = ofVec3f(triangles.triangles[j].c.x, triangles.triangles[j].c.y, 0.0);
//            
//            polygonesVertices.push_back(p1);
//            polygonesVertices.push_back(p2);
//            polygonesVertices.push_back(p3);
//            
//            polygonesIndices.push_back(polygonesIndices.size());
//            polygonesIndices.push_back(polygonesIndices.size());
//            polygonesIndices.push_back(polygonesIndices.size());
//            
//            polygoneVerticesColor.push_back(ofFloatColor(1.0, 0.0, 0.0));
//            polygoneVerticesColor.push_back(ofFloatColor(0.0, 1.0, 0.0));
//            polygoneVerticesColor.push_back(ofFloatColor(0.0, 0.0, 1.0));
//            
//            float angle1 = (p1 - p2).angleRad(p1 - p3);
//            float angle2 = (p2 - p3).angleRad(p2 - p1);
//            float angle3 = (p3 - p2).angleRad(p3 - p1);
//            
//            float h1 = sin(angle2) * (p2 - p1).length();
//            float h2 = sin(angle3) * (p3 - p2).length();
//            float h3 = sin(angle1) * (p1 - p3).length();
//            
//            polygonesAttributes.push_back(ofVec3f(h1, h2, h3));
//            polygonesAttributes.push_back(ofVec3f(h1, h2, h3));
//            polygonesAttributes.push_back(ofVec3f(h1, h2, h3));
//            
//        }
//        
//    }
//    
//    polygonesVbo.setVertexData(&polygonesVertices[0], (int) polygonesVertices.size(), GL_STATIC_DRAW);
//    polygonesVbo.setIndexData(&polygonesIndices[0], (int) polygonesIndices.size(), GL_STATIC_DRAW);
//    polygonesVbo.setColorData(&polygoneVerticesColor[0], (int) polygoneVerticesColor.size(), GL_STATIC_DRAW);
//    polygonesVbo.setNormalData(&polygonesAttributes[0], (int) polygonesAttributes.size(), GL_STATIC_DRAW);
    
    //Dashed polygones
    
    for(int i = 0; i < polygones.size(); i++){
        
        ofPolyline rawPolygone = polygones[i]->getRawPoligone();
        ofPolyline processedPolygone = rawPolygone.getResampledBySpacing(20);
        
        for(int j = 0; j < processedPolygone.getVertices().size(); j++){
            
            ofPoint currentVertice = processedPolygone.getVertices()[j];
            
            dashedPolygonesVertices.push_back(currentVertice);
            dashedPolygonesAttributes.push_back(ofVec3f(ofRandom(4.0, 7.0)));
            
        }
        
    }
    
    dashedPolygonesVbo.setVertexData(&dashedPolygonesVertices[0], (int) dashedPolygonesVertices.size(), GL_STATIC_DRAW);
    dashedPolygonesVbo.setNormalData(&dashedPolygonesAttributes[0], (int) dashedPolygonesAttributes.size(), GL_STATIC_DRAW);
    
}

//Where all the scene is rendered

void Scene::renderToScreen(){
    
    //Draw background.
    //This clears the last frame.
    
    ofEnableAlphaBlending();
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    //1 - Draw call
    //Draw particles tail.
    
    glLineWidth(2.0);
    
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    particleTailProgram.begin();
    particlesTailVbo.drawElements(GL_LINES, (int) tailIndices.size());
    particleTailProgram.end();
    ofDisableBlendMode();
    
    ofEnableAlphaBlending();
    
    //2 - Draw call
    //Draw all receptors
    
    receptorProgram.begin();
    receptorProgram.setUniform1f("alpha", getAlpha() / 255.0);
    receptorImg.bind();
    receptorsVbo.drawElements(GL_TRIANGLES, (int) receptorsIndices.size());
    receptorImg.unbind();
    receptorProgram.end();
    
    //3 - Draw call
    //Draw all emitters
    
    quadTextureProgram.begin();
    quadTextureProgram.setUniform1f("alpha", getAlpha() / 255.0);
    emitterImg.bind();
    emittersVbo.drawElements(GL_TRIANGLES, (int) emittersIndices.size());
    emitterImg.unbind();
    quadTextureProgram.end();
    
    //4 - Draw call
    //Draw all actuators
    
    simpleQuadTextureProgram.begin();
    simpleQuadTextureProgram.setUniform1f("alpha", getAlpha() / 255.0);
    actuatorImg.bind();
    actuatorsVbo.drawElements(GL_TRIANGLES, (int) actuatorsIndices.size());
    actuatorImg.unbind();
    simpleQuadTextureProgram.end();
    
    //5 - Draw call
    //Draw all actuators ring
    
    quadTextureProgram.begin();
    actuatorArrowImg.bind();
    actuatorsRingVbo.drawElements(GL_TRIANGLES, (int) actuatorsRingIndices.size());
    actuatorArrowImg.unbind();
    quadTextureProgram.end();
    
    //6 - Draw call
    //Draw dashed polygones,
    
    ofEnableAlphaBlending();
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    ofEnablePointSprites();
    dashedPolygoneProgram.begin();
    dashedPolygoneProgram.setUniform1f("alpha", getAlpha() / 255.0);
    dashedPolygoneImg.bind();
    dashedPolygonesVbo.draw(GL_POINTS, 0, (int) dashedPolygonesVertices.size());
    dashedPolygoneImg.unbind();
    dashedPolygoneProgram.end();
    ofDisablePointSprites();
    ofDisableBlendMode();
    
    //Draw interface -- NOT GPU BASED
    ofEnableAlphaBlending();
    
    ofSetColor(255, 255, 255, getAlpha());
    
    interface.draw();
    ofDisableAlphaBlending();
    
}

//Here we take all particles from all emitter end store them in a container to make rendering faster and dealing with them easier.
//We'll draw only once all particles.

void Scene::updateAllParticles(){
    
    allParticles.erase(allParticles.begin(), allParticles.end());
    
    for(int i = 0; i < emitters.size(); i++){
        
        vector<shared_ptr<Particle>> particles = emitters[i]->getParticles();
        allParticles.insert(allParticles.end(), particles.begin(), particles.end());
        
    }
    
}

void Scene::updateParticlesRenderingData(){
    
    for(int i = 0; i < MAX_PARTICLES; i++){
        
        if(i < allParticles.size()){
            
            positions[i] = allParticles[i]->getPosition();
            attributes[i].x = allParticles[i]->getMass() * 6; //Radius
            attributes[i].z = allParticles[i]->getLifeLeft() / allParticles[i]->getLifeSpan() * getAlpha() / 255.0; //Alpha
            
            vector<ofVec2f> points = allParticles[i]->getPoints();
            
            for(int j = 0; j < MAX_TAIL_LENGTH; j++){
                
                tailPoints[i * MAX_TAIL_LENGTH + j] = points[j];
                float alphaMutl = (float) j / MAX_TAIL_LENGTH + 0.05;
                tailColors[i * MAX_TAIL_LENGTH + j].a = allParticles[i]->getLifeLeft() / allParticles[i]->getLifeSpan() * alphaMutl - 0.1;
                
                //Fade out between screens
                
                tailColors[i * MAX_TAIL_LENGTH + j].a *= getAlpha() / 255.0;
                
            }
            
        }else{
            
            //Set all unused data unvisible
            
            attributes[i].x = 0; //Radius
            attributes[i].z = 0; //Alpha
            
            for(int j = 0; j < MAX_TAIL_LENGTH; j++){
                
                tailColors[i * MAX_TAIL_LENGTH + j].a = 0;
                
            }
            
        }
        
    }
    
    //Head
    
    particlesHeadVbo.updateVertexData(&positions[0], (int) positions.size());
    particlesHeadVbo.updateNormalData(&attributes[0], (int) attributes.size());
    
    //Tail
    
    particlesTailVbo.updateVertexData(&tailPoints[0], (int) tailPoints.size());
    particlesTailVbo.updateColorData(&tailColors[0], (int) tailColors.size());
    
}

void Scene::updateActuatorsRenderingData(){
    
    int currentRingVertexIndex = 0;
    
    for(int i = 0; i < actuators.size(); i++){
        
        //Set vertices
        
        vector<ofVec3f> quadVertices = getQuadVertices(50);
        
        ofMatrix4x4 mat;
        mat.glTranslate(actuators[i]->getPosition());
        
        actuatorsVertices[i * 4] = quadVertices[0] * mat;
        actuatorsVertices[i * 4 + 1] = quadVertices[1] * mat;
        actuatorsVertices[i * 4 + 2] = quadVertices[2] * mat;
        actuatorsVertices[i * 4 + 3] = quadVertices[3] * mat;
        
        //Set colors
        
        float alpha = ((actuators[i]->getPosition().y - actuatorBox.height / 2) / (actuatorBox.height / 2));
        
        //Ring
        
        for(int j = 0; j < 8; j++){
            
            float angle = (float) (360.0 / 8.0) * j;
            
            vector<ofVec3f> quadVertices = getQuadVertices(36);
            
            ofMatrix4x4 mat;
            mat.glTranslate(actuators[i]->getPosition());
            mat.glRotate(angle, 0, 0, 1);
            mat.glTranslate(0, actuators[i]->getRadius(), 0);
            
            actuatorsRingVertices[currentRingVertexIndex] = quadVertices[0] * mat;
            actuatorsRingVertices[currentRingVertexIndex + 1] = quadVertices[1] * mat;
            actuatorsRingVertices[currentRingVertexIndex + 2] = quadVertices[2] * mat;
            actuatorsRingVertices[currentRingVertexIndex + 3] = quadVertices[3] * mat;
            
            //Set color
            
            actuatorsRingColors[currentRingVertexIndex] = ofFloatColor(1.0, 1.0, 1.0, ofClamp(alpha, 0, getAlpha() / 255));
            actuatorsRingColors[currentRingVertexIndex + 1] = ofFloatColor(1.0, 1.0, 1.0, ofClamp(alpha, 0, getAlpha() / 255));
            actuatorsRingColors[currentRingVertexIndex + 2] = ofFloatColor(1.0, 1.0, 1.0, ofClamp(alpha, 0, getAlpha() / 255));
            actuatorsRingColors[currentRingVertexIndex + 3] = ofFloatColor(1.0, 1.0, 1.0, ofClamp(alpha, 0, getAlpha() / 255));
            
            currentRingVertexIndex += 4;
            
        }
        
    }
    
    actuatorsVbo.updateVertexData(&actuatorsVertices[0], (int) actuatorsVertices.size());
    
    actuatorsRingVbo.updateVertexData(&actuatorsRingVertices[0], (int) actuatorsRingVertices.size());
    actuatorsRingVbo.updateColorData(&actuatorsRingColors[0], (int) actuatorsRingColors.size());
    
}

void Scene::updateReceptorsRenderingData(){
    
    for(int i = 0; i < receptors.size(); i++){
        
        //Set vertices
        
        vector<ofVec3f> quadVertices = getQuadVertices(receptors[i]->getRadius() * 2);
        
        ofMatrix4x4 mat;
        mat.glTranslate(receptors[i]->getPosition());
        
        receptorsVertices[i * 4] = quadVertices[0] * mat;
        receptorsVertices[i * 4 + 1] = quadVertices[1] * mat;
        receptorsVertices[i * 4 + 2] = quadVertices[2] * mat;
        receptorsVertices[i * 4 + 3] = quadVertices[3] * mat;
        
        //Set attributes
        
        receptorsAttributes[i * 4] = (ofVec3f(receptors[i]->getRadius(), receptors[i]->getPercentFill() * 0.01, 0.0));
        receptorsAttributes[i * 4 + 1] = (ofVec3f(receptors[i]->getRadius(), receptors[i]->getPercentFill() * 0.01, 0.0));
        receptorsAttributes[i * 4 + 2] = (ofVec3f(receptors[i]->getRadius(), receptors[i]->getPercentFill() * 0.01, 0.0));
        receptorsAttributes[i * 4 + 3] = (ofVec3f(receptors[i]->getRadius(), receptors[i]->getPercentFill() * 0.01, 0.0));
        
    }
    
    receptorsVbo.updateVertexData(&receptorsVertices[0], (int) receptorsVertices.size());
    receptorsVbo.updateNormalData(&receptorsAttributes[0], (int) receptorsAttributes.size());
    
}

//Update the scene

void Scene::update(){
    
    //Update GPU data
    //This will update all the data related to the rendering of the particles.
    //The vbos conataining all rendering data as : heads coords, tails coords, etc... will be updated.
    
    updateParticlesRenderingData();
    
    //Here we update the main container of particles
    
    updateAllParticles();
    
    //Update particle system
    
    for(int i = 0; i < emitters.size(); i++){
        
        emitters[i]->update();
        emitters[i]->applyGravity(ofVec2f(0.0, 0.1));
        
    }
    
    //Update GPU data
    //This will update all the data related to the rendering of the actuators.
    //The vbos conataining all rendering data as : positions and radiuses will be updated.
    
    updateActuatorsRenderingData();
    
    //Update actuators
    
    for(int i = 0; i < touches.size(); i++){
        
        if(activeActuators[i] != nullptr && i < activeActuators.size()){
            ofVec2f force = (touches[i] - activeActuators[i]->getPosition()) * 1.4;
            activeActuators[i]->applyForce(force);
        }
        
    }
    
    for(int i = 0; i < actuators.size(); i++){
        
        actuators[i]->update();
        
        //Make actuators stick to teir initial position
        
        if (actuatorBox.inside(actuators[i]->getPosition())) {
            
            actuators[i]->enable(false);
            
            ofVec2f position = ofVec2f((ofGetWidth() / 2) - (ofGetWidth() / 4) + i * ((ofGetWidth() / 2) / (actuators.size() - 1)), actuatorBox.height / 2);
            
            ofVec2f force = (position - actuators[i]->getPosition());
            actuators[i]->applyForce(force);
            
        }else{
            
            actuators[i]->enable(true);
            
        }
    }
    
    //Receptors
    
    updateReceptorsRenderingData();
    
    //Check if receptors are filled
    
    if(!allAreFilled){
        
        allAreFilled = true;
        
        for(int i = 0; i < receptors.size(); i++){
            receptors[i]->update();
            if(!receptors[i]->isFilled()) allAreFilled = false;
        }
        
        if(allAreFilled){
            
            IS_FINISHED = true;
            levelEndCallback();
            
        }
        
    }
    
    checkForCollisions();
    
}

vector<ofVec3f> Scene::getQuadVertices(float _size){
    
    vector<ofVec3f> vertices;
    
    //Up / Left
    
    ofVec3f upLeft = ofVec3f(- _size / 2, - _size / 2);
    
    //Up / Right
    
    ofVec3f upRight = ofVec3f(_size / 2, - _size / 2);
    
    //Down / Right
    
    ofVec3f downRight = ofVec3f(_size / 2, _size / 2);
    
    //Down / Left
    
    ofVec3f downLeft = ofVec3f(- _size / 2, _size / 2);
    
    //Add vertices to the vector that will be returned.
    
    vertices.push_back(upLeft);
    vertices.push_back(upRight);
    vertices.push_back(downRight);
    vertices.push_back(downLeft);
    
    return vertices;
    
}

void Scene::checkForCollisions(){
    
    for(int i = 0; i < allParticles.size(); i++){
        
        ofVec2f currentPos = allParticles[i]->getPosition() + allParticles[i]->getVelocity();
        ofVec2f direction = -allParticles[i]->getVelocity().normalize();
        float maxDistRay = allParticles[i]->getVelocity().length() * 30;
        
        //First check if inside bounding box
        
        for(int j = 0; j < polygones.size(); j++){
            
            shared_ptr<Polygone> currentPoly = polygones[j];
            
            if(currentPoly->insideBoundingBox(currentPos)){
                
                if(currentPoly->inside(currentPos)){
                    
                    bool intersectionDetected = false;
                    
                    currentPoly->getParticleCollisionsInformations(currentPos, direction, maxDistRay, [&](ofVec2f intersection, ofVec2f normal){
                        
                        allParticles[i]->setPosition(intersection + normal);
                        float angle = direction.normalize().angleRad(normal.normalize());
                        ofVec2f bounceDirection = normal.rotateRad(angle).normalize();
                        allParticles[i]->setVelocity(allParticles[i]->getVelocity().length() * bounceDirection * 0.7);
                        
                        intersectionDetected = true;
                        
                    });

                    //Trigger sounds
                    
//                    if(ofGetElapsedTimeMillis() > lastPlay + playOffset){
//                        for(int k = 0; k < particlesSounds.size(); k++){
//                            
//                            if(!particlesSounds[k].isPlaying()){
//                                particlesSounds[k].play();
//                                cout << k << endl;
//                                lastPlay = ofGetElapsedTimeMillis();
//                                playOffset = ofRandom(50.0, 100.0);
//                                break;
//                            }
//                            
//                        }
//                    }
                    
                }
            
            }
            
        }
        
    }
    
}

void Scene::setPause(bool _pause){
    
    IS_PAUSED = _pause;
    
    for(int i = 0; i < emitters.size(); i++){
        
        emitters[i]->setPause(_pause);
        
    }
    
}

bool Scene::isFinished(){
    
    return IS_FINISHED;
    
}

//Player inputs
//These inputs will only fire when this screen is active

void Scene::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    
    if(_touch.id < touches.size()){
        touches[_touch.id] = _touch;
    }
    
    if(_touch.id < activeActuators.size()){
        
        for(int i = 0; i < actuators.size(); i++){
            
            if(actuators[i]->isOver(_touch)){
                
                activeActuators[_touch.id] = actuators[i];
                break;
                
            }
            
        }
        
    }
    
    interface.mouseDown(_touch, [&](string _text, string _action){
        _callback(_text, _action);
    });
    
    cout << "down" << endl;
    
}

void Scene::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    
    interface.mouseUp(_touch, [&](string _text, string _action){
        _callback(_text, _action);
    });
    
    //Reset the active actuator
    
    if(_touch.id < touches.size()){
        
        if(activeActuators[_touch.id] != nullptr){
            if(activeActuators[_touch.id]->isDisabled()) activeActuators[_touch.id]->disable(false);
        }
    
        activeActuators[_touch.id] = nullptr;
        
    }
    
    //Reset touch
    
    if(_touch.id < touches.size()){
        
        touches[_touch.id] = ofVec2f(INFINITY);
        
    }
    
}

void Scene::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    
    if(_touch.id < touches.size()){
        
        if(activeActuators[_touch.id] != nullptr){
         
            //If the actuator linked with the current touch is disabled just update its radius else its position.
            
            if(!activeActuators[_touch.id]->isDisabled()){
                
                touches[_touch.id] = _touch;
                
            }else{
                
                float distance = (activeActuators[_touch.id]->getPosition() - _touch).length();
                activeActuators[_touch.id]->setRadius(distance);
                
            }
            
        }
        
    }
    
}

void Scene::onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    if(_touch.id < touches.size()){
        
        for(int i = 0; i < actuators.size(); i++){
            
            if (actuators[i]->isOver(_touch)) {
                
                activeActuators[_touch.id] = actuators[i];
                activeActuators[_touch.id]->disable(true);
                
            }
            
        }
        
    }
    
}

void Scene::onEnd(function<void ()> _levelEndCallback){
    
    levelEndCallback = _levelEndCallback;
    
}

//Here we save all the scene settings in a XML file stored on the tablet.
//All levels are going to be stored like that.

void Scene::saveSceneToXML(string _fileName){
    
    ofxXmlSettings xml;
    
    //General
    
    xml.addTag("general");
    xml.pushTag("general");
    
    xml.addValue("ORIGINAL_WIDTH", ofGetWidth());
    xml.addValue("ORIGINAL_HEIGHT", ofGetHeight());
    xml.addValue("MAX_PARTICLES", MAX_PARTICLES);
    xml.addValue("MAX_TAIL_LENGTH", MAX_TAIL_LENGTH);
    xml.addValue("MAX_ACTUATORS_NUM", MAX_ACTUATORS_NUM);
    
    xml.popTag();
    
    //Emitters
    
    xml.addTag("emitters");
    xml.pushTag("emitters");
    
    for(int i = 0; i < emitters.size(); i++){
        
        xml.addTag("emitter");
        xml.pushTag("emitter", i);
        
        xml.addValue("X", emitters[i]->getPosition().x / ofGetWidth());
        xml.addValue("Y", emitters[i]->getPosition().y / ofGetHeight());
        xml.addValue("boxX", emitters[i]->getBoxSize().x / ofGetWidth());
        xml.addValue("boxY", emitters[i]->getBoxSize().y / ofGetHeight());
        xml.addValue("rate", emitters[i]->getRate());
        xml.addValue("maxParticles", emitters[i]->getMaxParticles());
        xml.addValue("maxTailLength", emitters[i]->getMaxTailLength());
        
        xml.popTag();
        
    }
    
    xml.popTag();
    
    //Actuators
    
    xml.addTag("actuators");
    xml.pushTag("actuators");
    
    xml.addValue("MAX_ACTUATORS_NUM", MAX_ACTUATORS_NUM);
    
    xml.popTag();
    
    //Fixed actuators
    
    xml.addTag("fixedActuators");
    xml.pushTag("fixedActuators");
    
    for(int i = 0; i < fixedActuators.size(); i++){
        
        xml.addTag("fixedActuator");
        xml.pushTag("fixedActuator", i);
        
        xml.addValue("X", fixedActuators[i]->getPosition().x / ofGetWidth());
        xml.addValue("Y", fixedActuators[i]->getPosition().y / ofGetHeight());
        xml.addValue("radius", fixedActuators[i]->getRadius() / ofGetWidth());
        xml.addValue("strength", fixedActuators[i]->getStrength());
        
        xml.popTag();
        
    }
    
    xml.popTag();
    
    //Receptors
    
    xml.addTag("receptors");
    xml.pushTag("receptors");
    
    for(int i = 0; i < receptors.size(); i++){
        
        xml.addTag("receptor");
        xml.pushTag("receptor", i);
        
        xml.addValue("X", receptors[i]->getPosition().x / ofGetWidth());
        xml.addValue("Y", receptors[i]->getPosition().y / ofGetHeight());
        xml.addValue("radius", receptors[i]->getRadius() / ofGetWidth());
        xml.addValue("strength", receptors[i]->getStrength());
        xml.addValue("maxParticles", receptors[i]->getMaxParticles());
        xml.addValue("decreasingFactor", receptors[i]->getDecreasingFactor());
        
        xml.popTag();
        
    }
    
    xml.popTag();
    
    //Polygones
    
    xml.addTag("polygones");
    xml.pushTag("polygones");
    
    for(int i = 0; i < polygones.size(); i++){
        
        //Polygone container
        xml.addTag("polygone");
        xml.pushTag("polygone", i);
        
        xml.addTag("vertices");
        xml.pushTag("vertices");
        
        for(int j = 0; j < polygones[i]->getVertices().size(); j++){
            
            xml.addTag("vertex");
            xml.pushTag("vertex", j);
            
            xml.addValue("X", polygones[i]->getVertices()[j].x / ofGetWidth());
            xml.addValue("Y", polygones[i]->getVertices()[j].y / ofGetHeight());
            xml.addValue("Z", polygones[i]->getVertices()[j].z);
            
            xml.popTag();
            
        }
        
        xml.addTag("indices");
        xml.pushTag("indices");
        
        for(int j = 0; j < polygones[i]->getIndices().size(); j++){
            
            xml.addValue("index", polygones[i]->getIndices()[j]);
            
        }
        
        xml.popTag();
        
        xml.popTag(); //vertice
        xml.popTag(); //vertices
    }
    
    xml.popTag();
    
    xml.saveFile(ofxiOSGetDocumentsDirectory() + _fileName);
    
}

//This function sets up the scene with a xml file.

void Scene::XMLSetup(string _xmlFile){
    
    ofxXmlSettings _XML;
    
    _XML.load(ofxiOSGetDocumentsDirectory() + _xmlFile);
    
    loadXML(_xmlFile, [&](ofxXmlSettings _XMLA){
        
        logXML(_xmlFile);
        XML = _XML;
        
        //Multitouch
        
        touches.erase(touches.begin(), touches.end());
        touches = vector<ofVec2f>(10, ofVec2f(INFINITY));
        
        //Main settings
        
        _XML.pushTag("general");
        
        ORIGINAL_WIDTH = _XML.getValue("ORIGINAL_WIDTH", 0);
        ORIGINAL_HEIGHT = _XML.getValue("ORIGINAL_HEIGHT", 0);
        MAX_PARTICLES = _XML.getValue("MAX_PARTICLES", 0);
        MAX_TAIL_LENGTH = _XML.getValue("MAX_TAIL_LENGTH", 0);
        MAX_ACTUATORS_NUM = _XML.getValue("MAX_ACTUATORS_NUM", 0);
        
        _XML.popTag();
        
        //Emitters
        
        //First reset emitters vector
        
        emitters.erase(emitters.begin(), emitters.end());
        
        //Get data from XML file
        
        _XML.pushTag("emitters");
        
        int numEmitters = _XML.getNumTags("emitter");
        
        for(int i = 0; i < numEmitters; i++){
            
            _XML.pushTag("emitter", i);
            
            ofVec2f position = ofVec2f(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
            ofVec2f boxSize = ofVec2f(_XML.getValue("boxX", 0.0) * ofGetWidth(), _XML.getValue("boxY", 0.0) * ofGetHeight());
            float rate = _XML.getValue("rate", 0.0);
            int maxParticles = _XML.getValue("maxParticles", 0);
            int maxTailLength = _XML.getValue("maxTailLength", 0);
            
            shared_ptr<ParticleSystem> newEmitter = shared_ptr<ParticleSystem>(new ParticleSystem);
            
            newEmitter->setPosition(position);
            newEmitter->setBoxSize(boxSize);
            newEmitter->setRate(rate);
            newEmitter->setMaxParticles(maxParticles);
            newEmitter->setMaxTailLength(maxTailLength);
            newEmitter->reset();
            
            emitters.push_back(newEmitter);
            
            _XML.popTag();
            
        }
        
        _XML.popTag();
        
        //Actuators
        
        actuators.erase(actuators.begin(), actuators.end());
        
        int numActuators = _XML.getValue("actuators:MAX_ACTUATORS_NUM", 0);
        
        activeActuators.erase(activeActuators.begin(), activeActuators.end());
        activeActuators = vector<shared_ptr<Actuator>>(numActuators, nullptr);
        
        for(int i = 0; i < numActuators; i++){
            
            ofVec2f position = ofVec2f(0, 0.0488281 * ofGetHeight() / 2);
            
            shared_ptr<Actuator> newActuator = shared_ptr<Actuator>(new Actuator());
            newActuator->setPosition(position);
            newActuator->setRadius(100 + ofRandom(350));
            newActuator->setOverRadius(100);
            newActuator->setMass(20);
            newActuator->setDamping(0.83);
            newActuator->setMaxVelocity(100);
            newActuator->setBox(0, 0, ofGetWidth(), ofGetHeight());
            newActuator->setStrength(-5);
            newActuator->enable(false);
            actuators.push_back(newActuator);
            
            for(int j = 0; j < emitters.size(); j++){
                emitters[j]->addActuator(newActuator);
            }
            
        }
        
        //Fixed actuators
        
        //Receptors
        
        receptors.erase(receptors.begin(), receptors.end());
        
        _XML.pushTag("receptors");
        
        int numReceptors = _XML.getNumTags("receptor");
        
        for(int i = 0; i < numReceptors; i++){
            
            _XML.pushTag("receptor", i);
            
            shared_ptr<Receptor> newReceptor = shared_ptr<Receptor>(new Receptor());
            
            ofVec2f position = ofVec2f(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
            float radius = _XML.getValue("radius", 0.0) * ofGetWidth();
            float strength = _XML.getValue("strength", 0.0);
            int maxParticles = _XML.getValue("maxParticles", 0);
            float decreasingFactor = _XML.getValue("decreasingFactor", 0.0);
            
            newReceptor->setPosition(position);
            newReceptor->setRadius(radius);
            newReceptor->setStrength(strength);
            newReceptor->setMaxParticles(maxParticles);
            newReceptor->setDecreasingFactor(decreasingFactor);
            
            receptors.push_back(newReceptor);
            
            for(int j = 0; j < emitters.size(); j++){
                emitters[j]->addReceptor(newReceptor);
            }
            
            _XML.popTag();
            
        }
        
        _XML.popTag();
        
        //Polygones
        
        _XML.pushTag("polygones");
        
        int numPolygones = _XML.getNumTags("polygone");
        
        for(int i = 0; i < numPolygones; i++){
            
            _XML.pushTag("polygone", i);
            
            shared_ptr<Polygone> newPolygone = shared_ptr<Polygone>(new Polygone());
            
            _XML.pushTag("vertices");
            
            int numVertices = _XML.getNumTags("vertex");
            
            for(int j = 0; j < numVertices; j++){
                
                _XML.pushTag("vertex", j);
                
                newPolygone->addVertex(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
                
                _XML.popTag();
                
            }
            
            _XML.popTag();
            
            polygones.push_back(newPolygone);
            
            _XML.popTag();
            
        }
        
        _XML.popTag();
        
    });
    
    //Set up all the GPU data needed for rendering the scene once we loaded all our game components.
    
    initializeGPUData();
    
}























