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
    
    particleSystem.init();
    particleSystem.setPosition(ofVec2f(ofGetWidth() / 2, 200));
    particleSystem.setBoxSize(ofVec2f(ofGetWidth() / 3, 1));
    particleSystem.setRate(150);
    particleSystem.setMaxParticles(MAX_PARTICLES);
    
    //Rendering
    
    //Load custom shaders and create the program
    
    particleHeadProgram.load("shaders/particleHead");
    
    //Set un vbo for rendering the particles
    
    positions = vector<ofVec3f>(MAX_PARTICLES, ofVec3f(0));
    attributes = vector<ofVec3f>(MAX_PARTICLES, ofVec3f(0));
    
    particlesHeadVbo.setVertexData(&positions[0], (int) positions.size(), GL_DYNAMIC_DRAW);
    particlesHeadVbo.setNormalData(&attributes[0], (int) attributes.size(), GL_STATIC_DRAW);
    
    updateParticlesRendering();
    
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
        particleSystem.addActuator(newActuator);
        
    }
    
    //Initialize some receptors
    
    receptors.empty();
    
    for(int i = 0; i < 1; i++){
        
        shared_ptr<Receptor> newReceptor = shared_ptr<Receptor>(new Receptor());
        newReceptor->setPosition(ofVec2f(ofGetWidth() / 2, ofGetHeight()));
        newReceptor->setRadius(150.0);
        newReceptor->setStrength(5.0);
        receptors.push_back(newReceptor);
        particleSystem.addReceptor(newReceptor);
        
    }
    
    //Initialize some polygones (obstacle)
    
    polygones.empty();
    
    shared_ptr<Polygone> polygone = shared_ptr<Polygone>(new Polygone());
    polygone->addVertex(ofGetWidth() / 2, 1000);
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
    
}

//Where all the scene is rendered
void Scene::renderToScreen(){
    
    //Draw background
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
    
    //Draw particles
    
    updateParticlesRendering();
    
    ofEnablePointSprites();
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    
    particleHeadProgram.begin();
    particleImg.bind();
    
    particlesHeadVbo.draw(GL_POINTS, 0, (int) positions.size());
    
    particleImg.unbind();
    particleHeadProgram.end();
    
    ofDisableBlendMode();
    ofDisablePointSprites();
    
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
    
    interface.draw(getAlpha());
    
}

void Scene::updateParticlesRendering(){
    
    vector<shared_ptr<Particle>> particles = particleSystem.getParticles();
    
    for(int i = 0; i < MAX_PARTICLES; i++){
        if(i < particles.size()){
            
            positions[i] = particles[i]->getPosition();
            attributes[i].x = particles[i]->getMass() * 10; //Radius
            attributes[i].z = particles[i]->getLifeLeft() / particles[i]->getLifeSpan(); //Alpha
            
        }else{
            
            attributes[i].x = 0; //Radius
            attributes[i].z = 0; //Alpha
            
        }
    }
    
    particlesHeadVbo.updateVertexData(&positions[0], (int) positions.size());
    particlesHeadVbo.updateNormalData(&attributes[0], (int) attributes.size());
    
}

void Scene::update(){
    
    //Update particle system
    
    particleSystem.update();
    particleSystem.applyGravity(ofVec2f(0.0, 0.1));
    
    vector<shared_ptr<Particle>> particles = particleSystem.getParticles();
    
    for(int i = particles.size() - 1; i >= 0 ; i--){
        for(int j = 0; j < receptors.size(); j++){
         
            float distance = (particles[i]->getPosition() - receptors[j]->getPosition()).length();
            
            if(distance < 50){
                particleSystem.removeParticle(i);
                receptors[j]->addOneParticleToCount();
            }
            
        }
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
    
    vector<shared_ptr<Particle>> particles = particleSystem.getParticles();
    
    for(int i = 0; i < particles.size(); i++){
        
        ofVec2f currentPos = particles[i]->getPosition() + particles[i]->getVelocity();
        ofVec2f direction = -particles[i]->getVelocity().normalize();
        float maxDistRay = particles[i]->getVelocity().length() * 30;
        
        //First check if inside bounding box
        
        for(int j = 0; j < polygones.size(); j++){
            
            shared_ptr<Polygone> currentPoly = polygones[j];
            
            if(currentPoly->insideBoundingBox(currentPos)){
                
                if(currentPoly->inside(currentPos)){
                    
                    bool intersectionDetected = false;
                    
                    currentPoly->getParticleCollisionsInformations(currentPos, direction, maxDistRay, [&](ofVec2f intersection, ofVec2f normal){
                        
                        particles[i]->setPosition(intersection + normal);
                        float angle = direction.normalize().angleRad(normal.normalize());
                        ofVec2f bounceDirection = normal.rotateRad(angle).normalize();
                        particles[i]->setVelocity(particles[i]->getVelocity().length() * bounceDirection * 0.7);
                        
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

void Scene::XMLSetup(){
    
    
    
}