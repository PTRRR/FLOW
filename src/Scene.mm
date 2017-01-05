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
    
    initializeGPUData();
    
};

void Scene::initializeGPUData(){
    
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
    
    updateAllParticles();
    
    loadXML("scene_1.xml", [&](ofxXmlSettings _XML){
    
        saveXML("scene_1.xml", _XML);
        
        logXML("scene_1.xml");
        
    });

//    logXML("scene_1.xml");
    XMLSetup("scene_1.xml");
    
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
    
    if(allAreFilled){
    
        XMLSetup("scene_1.xml");
        
    }
    
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
        
        xml.popTag(); //vertice
        xml.popTag(); //vertices
    }
    
    xml.popTag();
    
    xml.saveFile(ofxiOSGetDocumentsDirectory() + _fileName);
    
}

void Scene::saveXML(string _name, ofxXmlSettings _XML){
    
    string message = "";
    
    if( _XML.saveFile(_name) ){
        
        message = _name + " saved in the data folder!";
        
    }else if( _XML.saveFile(ofxiOSGetDocumentsDirectory() + _name) ){
        
        message = _name + " saved in the documents folder!";
        
    }else{
        
        message = "Unable to save " + _name + " check data/ folder";
        
    }
    
    cout << message << endl;
    
}

void Scene::loadXML(string _xmlFile, function<void(ofxXmlSettings _XML)> _callback){
    
    ofxXmlSettings XML;
    
    string message = "";
    
    if( XML.loadFile(_xmlFile) ){
        
        message = _xmlFile + " loaded from data folder!";
        cout << message << endl;
        
        _callback(XML);
        
    }else if( XML.loadFile(ofxiOSGetDocumentsDirectory() + _xmlFile) ){
        
        message = _xmlFile + " loaded from documents folder!";
        cout << message << endl;
        
        _callback(XML);
        
    }else{
        
        message = "unable to load " + _xmlFile + " check data/ folder";
        cout << message << endl;
        
    }
    
}

void Scene::logXML(string _fileName){
    
    loadXML(_fileName, [&](ofxXmlSettings _xml){
        
        string content;
        
        _xml.copyXmlToString(content);
        
        cout << content << endl;
        
    });
    
}

void Scene::XMLSetup(string _xmlFile){
    
    loadXML(_xmlFile, [&](ofxXmlSettings _XML){
    
        logXML(_xmlFile);
        
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
        
        for(int i = 0; i < numActuators; i++){
            
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
        
        //Fixed actuators
        
        //Receptors
        
        receptors.erase(receptors.begin(), receptors.end());
        
        _XML.pushTag("receptors");
        
        int numReceptors = _XML.getNumTags("receptor");
        
        for(int i = 0; i < numReceptors; i++){
            
            _XML.pushTag("receptor", i);
            
            shared_ptr<Receptor> newReceptor = shared_ptr<Receptor>(new Receptor());
            
            ofVec2f position = ofVec2f(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0) * ofGetHeight());
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
    
}























