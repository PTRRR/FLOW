//
//  ParticleSystem.mm
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#include "ParticleSystem.h"

ParticleSystem::ParticleSystem(){
    
    paused = false;

    boxSize = ofVec2f(0);
    rate = 1.0;
    maxParticles = 100;
    updateRate = 10; //ms
    elapsedTime = 0;
    toEmit = 0;
    maxTailLength = 0;

}

void ParticleSystem::reset(){
    
    particles.erase(particles.begin(), particles.end());
    actuators.erase(actuators.begin(), actuators.end());
    receptors.erase(receptors.begin(), receptors.end());
    
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

            if(!paused) addParticles(floor(toEmit));
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
            
            //Erase particle if to close of the receptor.
            
            float distance = (particles[i]->getPosition() - receptors[j]->getPosition()).length();
            
            if(distance < 20){
                particles.erase(particles.begin() + i);
                receptors[j]->addOneParticleToCount();
            }
            
        }
        
        //Apply that force.
        
        particles[i]->applyForce(force);
        
        //Apply random force to add some randomness to the movements.
        
        particles[i]->applyForce(ofVec2f(ofRandomf() * 0.3));
        
        //Update the current particle,
        
        particles[i]->update();
        
    }
    
    //Check dead particles.
    
    for(int i = particles.size() - 1; i >= 0; i--){
        
        if(particles[i]->isDead() || particles[i]->isOut()){
            particles.erase(particles.begin() + i);
        }
        
    }
    
    //Update the physics of the particle system itself.
    
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
        newParticle->setMass(ofRandom(3.0));
        newParticle->setVelocity(ofVec2f(ofRandomf() * 2, 0));
        newParticle->setMaxVelocity(20);
        newParticle->setBox(-100, -100, ofGetWidth() + 200, ofGetHeight() + 200);
        newParticle->setLifeSpan(ofRandom(15000));
        newParticle->setNumPoints(maxTailLength);
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

void ParticleSystem::setMaxTailLength(int _length){
    
    maxTailLength = _length;
    
}

void ParticleSystem::setPause(bool _pause){
    
    paused = _pause;
    
    for(int i = 0; i < particles.size(); i++){
        particles[i]->disable(_pause);
    }
    
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

ofVec2f ParticleSystem::getBoxSize(){
    
    return boxSize;
    
}

int ParticleSystem::getMaxTailLength(){
    
    return maxTailLength;
    
}