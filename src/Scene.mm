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
    
    //Load the shader in order to draw the background
    //This shader will draw the contours of the magnetic field
    
//    loadBackgroundShader();
    
    
    //Initialize the emitter
    
    particleSystem.setPosition(ofVec2f(ofGetWidth() / 2, 200));
    particleSystem.setBoxSize(ofVec2f(100, 10));
    particleSystem.setRate(80);
    particleSystem.setMaxParticles(300);
    
    //Set up some actuators
    
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
    
    for(int i = 0; i < 1; i++){
        
        shared_ptr<Receptor> newReceptor = shared_ptr<Receptor>(new Receptor());
        newReceptor->setPosition(ofVec2f(ofGetWidth() / 2, ofGetHeight()));
        newReceptor->setRadius(150.0);
        newReceptor->setStrength(5.0);
        receptors.push_back(newReceptor);
        particleSystem.addReceptor(newReceptor);
        
    }
    
    //Initialize some polygones (obstacle)
    
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
    
};

//Where all the scene is rendered
void Scene::renderToScreen(){
    
    //Draw background
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
    
    //Draw particles
    
    particleSystem.debugDraw();
    
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
    
    for(int i = 0; i < receptors.size(); i++){
        receptors[i]->update();
    }
    
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

//Load backgroud shader
//This function loads and pass some uniforms to the shader : screen resolution, max number of magnets

//void Scene::loadBackgroundShader(){
//    
//    //Create the shader program for the background
//    
//    backGroundShader = gl::GlslProg::create(gl::GlslProg::Format().vertex(loadResource("LevelCurves.vert")).fragment(loadResource("LevelCurves.frag")));
//    
//    //Pass some uniforms to the shader
//    //The max number of magnets is useful to set the array of magnets in the fragment shader
//    
//    backGroundShader->uniform("uMaxNumber", MAX_MAGNET_NUM);
//    backGroundShader->uniform("uScreenResolution", vec2(getWindowWidth(), getWindowHeight()));
//    
//}

//Update uniforms in the fragment shader
//The position of the magnets and their strength

//void Scene::updateBackgroudShader(){
//    
//    for (int i = 0; i < magnets.size(); i++) {
//        
//        //Set uTime
//        backGroundShader->uniform("uTime", time);
//        
//        //Set uMagnetPos
//        string magnetPosIndex = "uMagnetPos[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetPosIndex, magnets[i]->getPosition());
//        
//        //Set uMagnetStrength
//        string magnetStrengthIndex = "uMagnetStrength[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetStrengthIndex, magnets[i]->getStrength());
//        
//        //Set uMagnetRadiusOfAction
//        string magnetRadiusIndex = "uMagnetRadius[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetRadiusIndex, magnets[i]->getRadius());
//        
//        //Set uMagnetRadiusOfAction
//        string magnetRadiusOfActionIndex = "uMagnetRadiusOfAction[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetRadiusOfActionIndex, magnets[i]->getRadiusOfAction());
//        
//    }
//    
//}

void Scene::onEnd(function<void ()> _levelEndCallback){
    
    levelEndCallback = _levelEndCallback;
    
}

//This function loads a scene from a XML file
//All levels are contained in a XML file

void Scene::XMLSetup(){
    
    
    
}