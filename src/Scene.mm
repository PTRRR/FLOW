//
//  Scene.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "Scene.h"

Scene::Scene(){}

Scene::Scene(shared_ptr<ofTrueTypeFont> _mainFont){
    
    time = 0.0f;
    
    //Create the user interface : MENU button
    
    interface = Interface(_mainFont);
    interface.addButton("MENU", "MENU", ofVec2f(ofGetWidth() - _mainFont->stringWidth("MENU"), 50));
    
    initialize();
    
};

void Scene::initialize(){
    
    //Initialize the emitter
    
    shared_ptr<ParticleSystem> particleSystem = shared_ptr<ParticleSystem>(new ParticleSystem());
    
    particleSystem->setPosition(ofVec2f(ofGetWidth() / 2 - 200, 200));
    particleSystem->setBoxSize(ofVec2f(10, 1));
    particleSystem->setRate(60);
    
    //These two parameters need a init call
    
    particleSystem->setMaxParticles(MAX_PARTICLES / 2);
    particleSystem->setMaxTailLength(MAX_TAIL_LENGTH);
    particleSystem->init(); //initialize the emitter with all new parameters
    
    emitters.push_back(particleSystem);
    
    shared_ptr<ParticleSystem> particleSystem1 = shared_ptr<ParticleSystem>(new ParticleSystem());
    
    particleSystem1->setPosition(ofVec2f(ofGetWidth() / 2 + 200, 200));
    particleSystem1->setBoxSize(ofVec2f(10, 1));
    particleSystem1->setRate(60);
    
    //These two parameters need a init call
    
    particleSystem1->setMaxParticles(MAX_PARTICLES / 2);
    particleSystem1->setMaxTailLength(MAX_TAIL_LENGTH);
    particleSystem1->init(); //initialize the emitter with all new parameters
    
    emitters.push_back(particleSystem1);
    
    
    //GPU Rendering
    //Load custom shaders and create the program
    
    particleHeadProgram.load("shaders/particleHead");
    particleTailProgram.load("shaders/particleTail");
    
    //Set un vbo for rendering the particles head
    
    positions = vector<ofVec3f>(MAX_PARTICLES, ofVec3f(0));
    attributes = vector<ofVec3f>(MAX_PARTICLES, ofVec3f(0));
    
    particlesHeadVbo.setVertexData(&positions[0], (int) positions.size(), GL_DYNAMIC_DRAW);
    particlesHeadVbo.setNormalData(&attributes[0], (int) attributes.size(), GL_STATIC_DRAW);
    
    //Set un vbo for rendering the particles tail
    //20 is the max number of points composing the particle tail
    
    tailPoints = vector<ofVec3f>(MAX_PARTICLES * MAX_TAIL_LENGTH, ofVec3f(0));
    tailColors = vector<ofFloatColor>(MAX_PARTICLES * MAX_TAIL_LENGTH, ofFloatColor(1.0, 1.0, 1.0, 0.0));
    
    for(int i = 0; i < MAX_PARTICLES; i++){
        
        for(int j = 0; j < MAX_TAIL_LENGTH - 1; j++){
            
            tailIndices.push_back(i * MAX_TAIL_LENGTH + j);
            tailIndices.push_back(i * MAX_TAIL_LENGTH + j + 1);
            
        }
        
    }
    
    particlesTailVbo.setVertexData(&tailPoints[0], (int) tailPoints.size(), GL_STREAM_DRAW);
    particlesTailVbo.setColorData(&tailColors[0], (int) tailColors.size(), GL_STREAM_DRAW);
    particlesTailVbo.setIndexData(&tailIndices[0], (int) tailIndices.size(), GL_STATIC_DRAW);
    
    //Update GPU data
    
    updateParticlesRenderingData();
    
    //Load particle texture
    
    particleImg.load("images/particleTex_1.png");
    
    //Set up some actuators
    
    actuators.empty();
    
    for(int i = 0; i < 3; i++){
        
        shared_ptr<Actuator> newActuator = shared_ptr<Actuator>(new Actuator());
        newActuator->setPosition(ofVec2f(ofRandom(ofGetWidth()), ofRandom(ofGetHeight())));
        newActuator->setRadius(100 + ofRandom(350));
        newActuator->setMass(20);
        newActuator->setDamping(0.84);
        newActuator->setMaxVelocity(100);
        newActuator->setBox(0, 0, ofGetWidth(), ofGetHeight());
        newActuator->setStrength(-5);
        actuators.push_back(newActuator);
        
        for(int j = 0; j < emitters.size(); j++){
            emitters[j]->addActuator(newActuator);
        }
        
    }
    
    //Initialize some receptors
    
    receptors.empty();
    
    for(int i = 0; i < 1; i++){
        
        shared_ptr<Receptor> newReceptor = shared_ptr<Receptor>(new Receptor());
        newReceptor->setPosition(ofVec2f(ofGetWidth() / 2, ofGetHeight()));
        newReceptor->setRadius(200.0);
        newReceptor->setStrength(5.0);
        receptors.push_back(newReceptor);
        
        for(int j = 0; j < emitters.size(); j++){
            emitters[j]->addReceptor(newReceptor);
        }
        
    }
    
    //Initialize some polygones (obstacle)
    
    polygones.empty();
    
    shared_ptr<Polygone> polygone = shared_ptr<Polygone>(new Polygone());
    polygone->addVertex(ofGetWidth() / 2, 600);
    polygone->addVertex(ofGetWidth() / 2 + 200, 800);
    polygone->addVertex(ofGetWidth() / 2 + 200, 1100);
    polygone->addVertex(ofGetWidth() / 2 - 200, 1100);
    polygone->addVertex(ofGetWidth() / 2 - 200, 800);
    
    polygones.push_back(polygone);
    
    shared_ptr<Polygone> polygone1 = shared_ptr<Polygone>(new Polygone());
    polygone1->addVertex(100, 1000);
    polygone1->addVertex(ofGetWidth() / 2 - 200, 1900);
    polygone1->addVertex(100, 1900);
    
    polygones.push_back(polygone1);
    
    shared_ptr<Polygone> polygone2 = shared_ptr<Polygone>(new Polygone());
    polygone2->addVertex(ofGetWidth() - 100, 1000);
    polygone2->addVertex(ofGetWidth() / 2 + 200, 1900);
    polygone2->addVertex(ofGetWidth() - 100, 1900);
    
    polygones.push_back(polygone2);

    
    updateAllParticles();
    
}

//Where all the scene is rendered
void Scene::renderToScreen(){
    
    //Draw background
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    //Update main particle container
    
//    updateAllParticles();
    
    //Update GPU data
    //This will update all the data related to the rendering of the particles
    
    updateParticlesRenderingData();
    
    //Draw particles tail
    
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    ofEnableAlphaBlending();
    
    particleTailProgram.begin();
    
    particlesTailVbo.drawElements(GL_LINES, (int) tailIndices.size());
    
    particleTailProgram.end();
    
    //Draw particles head

    ofEnablePointSprites();
    
    particleHeadProgram.begin();
    particleImg.bind();
    
    particlesHeadVbo.draw(GL_POINTS, 0, (int) positions.size());
    
    particleImg.unbind();
    particleHeadProgram.end();
    
    ofDisablePointSprites();
    
    ofDisableAlphaBlending();
    ofDisableBlendMode();
    
    ofSetColor(255, 255, 255, getAlpha());
    
    //Draw actuators
    
    for(int i = 0; i < actuators.size(); i++){
        actuators[i]->debugDraw();
    }
    
    //Draw receptors
    
    for(int i = 0; i < receptors.size(); i++){
        receptors[i]->debugDraw();
    }
    
    //Draw polygones
    
    for(int i = 0; i < polygones.size(); i++){
        polygones[i]->debugDraw();
    }
    
    //Draw interface
    
    interface.draw();
    
    updateAllParticles();
    
}

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
            attributes[i].x = allParticles[i]->getMass() * 10; //Radius
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

void Scene::update(){
    
    updateAllParticles();
    
    //Update particle system
    
    for(int i = 0; i < emitters.size(); i++){
     
        emitters[i]->update();
        emitters[i]->applyGravity(ofVec2f(0.0, 0.1));
        
    }
        
    //Update actuators
    
    if(activeActuator != nullptr){
        
        ofVec2f force = touchPos - activeActuator->getPosition();
        activeActuator->applyForce(force);
        
    }
    
    for(int i = 0; i < actuators.size(); i++){
        actuators[i]->update();
    }
    
    //Update receptors
    
    bool allAreFilled = true;
    
    for(int i = 0; i < receptors.size(); i++){
        receptors[i]->update();
        if(!receptors[i]->isFilled()) allAreFilled = false;
    }
    
    if(allAreFilled) initialize();
    
    checkForCollisions();
    
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
                    
                    if(!intersectionDetected){
                        //particles[i]->setLifeSpan(0);
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

//Player inputs
//These inputs will only fire when this screen is active

void Scene::onMouseDown(ofVec2f _position, function<void(string _text, string _action)> _callback){

    touchPos = ofVec2f(_position.x, _position.y);
    
    for(int i = 0; i < actuators.size(); i++){
        
        if(actuators[i]->isOver(touchPos)){
            
            activeActuator = actuators[i];
            break;
            
        }
        
        if(i == actuators.size() - 1 && activeActuator == nullptr){
            
//            particleSystem.empty();
            
        }
        
    }
    
    interface.mouseDown(_position, [&](string _text, string _action){
        _callback(_text, _action);
    });
    
}

void Scene::onMouseUp(ofVec2f _position, function<void(string _text, string _action)> _callback){
    
    activeActuator = nullptr;
    
    interface.mouseUp(_position, [&](string _text, string _action){
        _callback(_text, _action);
    });
    
}

void Scene::onMouseMove(ofVec2f _position, function<void(string _text, string _action)> _callback){
    
    touchPos = ofVec2f(_position.x, _position.y);
    
}

void Scene::onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> _callback){
    
    
    
}

void Scene::onEnd(function<void ()> _levelEndCallback){
    
    levelEndCallback = _levelEndCallback;
    
}

//This function loads a scene from a XML file
//All levels are contained in a XML file

void Scene::saveSceneToXML(string _fileName){
    
    ofxXmlSettings xml;
    
    //Actuators
    
    xml.addTag("actuators");
    xml.pushTag("actuators");
    
    xml.addValue("num", (int) actuators.size());
    
    xml.popTag();
    
    //Receptors
    
    xml.addTag("receptors");
    xml.pushTag("receptors");
    
    xml.addValue("num", (int) receptors.size());
    
    for(int i = 0; i < receptors.size(); i++){
        
        xml.addTag("receptor");
        xml.pushTag("receptor", i);
        
        xml.addValue("X", receptors[i]->getPosition().x / ofGetWidth());
        xml.addValue("Y", receptors[i]->getPosition().y / ofGetHeight());
        xml.addValue("strength", receptors[i]->getStrength());
        xml.addValue("radius", receptors[i]->getRadius());
        
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
        
        xml.popTag(); //vertice
        xml.popTag(); //vertices
    }
    
    xml.popTag();
    
    xml.saveFile(ofxiOSGetDocumentsDirectory() + "level_1.xml");
    
    loadXML("level_1.xml", [&](ofxXmlSettings _xml){
        
        string content;
        
        _xml.copyXmlToString(content);
        
        cout << content << endl;
        
    });
    
}

void Scene::XMLSetup(string _xmlFile){
    
    string message = "";
    
    if( XML.loadFile(ofxiOSGetDocumentsDirectory() + _xmlFile + ".xml") ){
        message = "mySettings.xml loaded from documents folder!";
    }else if( XML.loadFile(_xmlFile) ){
        message = "mySettings.xml loaded from data folder!";
    }else{
        message = "unable to load mySettings.xml check data/ folder";
    }
    
    cout << message << endl;
    
}