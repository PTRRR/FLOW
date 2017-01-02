//
//  ParticleSystem.mm
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#include "ParticleSystem.h"

ParticleSystem::ParticleSystem(){

    boxSize = ofVec2f(0);
    rate = 1.0;
    maxParticles = 100;
    updateRate = 10; //ms
    elapsedTime = 0;
    toEmit = 0;

}

void ParticleSystem::init(){
    
    particles.empty();
    actuators.empty();
    receptors.empty();
    
}

void ParticleSystem::debugDraw(){

    ofPushStyle();
    ofSetColor(255, 100, 60);
    ofDrawCircle(getPosition(), 7);
    ofPopStyle();
    
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    
    for(int i = 0; i < particles.size(); i++){
        
        particles[i]->debugDraw();
        
    }
    
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    
}

void ParticleSystem::update(){
    
    //How many times the emitter size will be updated in on second according to the
    //update rate variable.
    
    float updateTimesPerSec = 1000 / updateRate;
    
    //When the elapsed time is greater than the update rate, increment the variable "toEmit".
    //The elapsed time is then set to zero to restart the timeout.
    
    elapsedTime += getDeltatime();
    
    if(elapsedTime > updateRate){
        
        //This keeps track of the additional time. This keeps the value "elapsedTime" under 1000.
        
        elapsedTime -= floor(elapsedTime / updateRate) * updateRate;
        
        //Increment toEmit to determine how many particles should be added to the emitter every
        //(updateRate) milliseconds.
        
        if(particles.size() <= maxParticles) toEmit += rate / updateTimesPerSec;
        
        //If the variable to emit is greater than one, add particles.
        //The number to add is determined by the floored value of toEmit since toEmit is a floating
        //value.
        //Then we subtrack the emitted number of particules to the "toEmit" variable
        
        if(floor(toEmit) >= 1){

            addParticles(floor(toEmit));
            toEmit -= floor(toEmit);
            
        }
        
    }
    
    //Update particles
    
    for(int i = 0; i < particles.size(); i++){
        
        //Calculate the force emitted by the actuators at the particle's position
        
        ofVec2f force = ofVec2f(0);
        
        for(int j = 0; j < actuators.size(); j++){
            
            force += actuators[j]->getForceAtPoint(particles[i]->getPosition());
            
        }
        
        for(int j = 0; j < receptors.size(); j++){
            
            force += receptors[j]->getForceAtPoint(particles[i]->getPosition());
            
        }
        
        //Apply that force
        
        particles[i]->applyForce(force);
        
        //Separation algorithme --> very expensive
        
//        float maxDist = 15.0;
//        
//        for(int k = 0; k < particles.size(); k++){
//            
//            if(particles[i] != particles[k]){
//                
//                ofVec2f direction = particles[i]->getPosition() - particles[k]->getPosition();
//                float dist = direction.length();
//                
//                if(dist < maxDist){
//                    
//                    ofVec2f repulsionForce = direction * (dist / maxDist) * 0.01f;
//                    repulsionForce *= 0.1;
//                    particles[i]->applyForce(repulsionForce);
//                    
//                }
//                
//            }
//            
//        }
        
        particles[i]->update();
        
    }
    
    //Check dead particles
    
    for(int i = particles.size() - 1; i >= 0; i--){
        
        if(particles[i]->isDead() || particles[i]->isOut()){
            particles.erase(particles.begin() + i);
        }
        
    }
    
    //Update the physics of the particle system itself
    
    ParticleSystem::BaseElement::update();
    
}

void ParticleSystem::applyGravity(ofVec2f _gravity){
    
    for(int i = 0; i < particles.size(); i++){
        
        particles[i]->applyForce(_gravity * particles[i]->getMass());
        
        
    }
    
}

void ParticleSystem::applyForce(ofVec2f _force){
    
    for(int i = 0; i < particles.size(); i++){
        
        particles[i]->applyForce(_force);
        
    }
    
}

void ParticleSystem::addParticles(int _num){
    
    for(int i = 0; i < _num; i++){
        
        shared_ptr<Particle> newParticle = shared_ptr<Particle>(new Particle(ofVec2f( getPosition().x + ofRandomf() * boxSize.x, getPosition().y + ofRandomf() * boxSize.y )));
//        newParticle->setPosition(ofVec2f( getPosition().x + ofRandomf() * boxSize.x, getPosition().y + ofRandomf() * boxSize.y ));
        newParticle->setMass(ofRandom(3.0));
        newParticle->setVelocity(ofVec2f(ofRandomf() * 0, 0));
        newParticle->setMaxVelocity(20);
        newParticle->setBox(-100, -100, ofGetWidth() + 200, ofGetHeight() + 200);
        newParticle->setLifeSpan(ofRandom(10000));
        particles.push_back(newParticle);
        
    }
    
}

void ParticleSystem::removeParticle(int _index){
    
    particles.erase(particles.begin() + _index);
    
}

void ParticleSystem::addActuator(shared_ptr<Actuator> _actuator){
    
    actuators.push_back(_actuator);
    
}

void ParticleSystem::addReceptor(shared_ptr<Receptor> _receptor){
    
    receptors.push_back(_receptor);
    
}

void ParticleSystem::removeActuator(shared_ptr<Actuator> _actuator){
    
    for(int i = actuators.size() - 1; i >= 0; i--){
        
        if(actuators[i] == _actuator){
            actuators.erase(actuators.begin() + i);
            break;
        }
        
    }
    
}

//Set

void ParticleSystem::setBoxSize(ofVec2f _boxSize){

    boxSize = _boxSize;
    
}

void ParticleSystem::setRate(float _rate){
    
    rate = _rate;
    
}

void ParticleSystem::empty(){
    
    for(int i = particles.size() - 1; i >= 0; i--){
        
        particles.erase(particles.begin() + i);
        
    }
    
}

void ParticleSystem::setMaxParticles(int _maxParticles){
    
    maxParticles = _maxParticles;
    
}

//Get

vector<shared_ptr<Particle>> ParticleSystem::getParticles(){
    
    return particles;
    
}

float ParticleSystem::getRate(){
    
    return rate;
    
}

int ParticleSystem::getMaxParticles(){
    
    return maxParticles;
    
}