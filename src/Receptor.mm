//
//  Receptor.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 30.12.16.
//
//

#include "Receptor.h"

Receptor::Receptor(){}

void Receptor::update(){
    
    Receptor::Actuator::update();
    
    if(!filled){
        particlesCount -= getDeltatime() * decreasingFactor * (particlesCount / maxParticles);
        particlesCount = ofClamp(particlesCount, 0, maxParticles);
    }
    
    if (getPercentFill() == 100) {
        particlesCount = maxParticles;
        filled = true;
    }
    
}

void Receptor::debugDraw(){
    
    Receptor::Actuator::debugDraw();
    ofDrawBitmapString(to_string((int) getPercentFill()) + "%", getPosition().x, getPosition().y - 30);
    
}

//Set

void Receptor::addOneParticleToCount(){
    
    if(!filled) particlesCount ++;
    
}

void Receptor::setDecreasingFactor(float _decreasingFactor){
    
    decreasingFactor = _decreasingFactor;
    
}

void Receptor::setMaxParticles(int _maxParticles){
    
    maxParticles = _maxParticles;
    
}

//Get

float Receptor::getPercentFill(){
    
    return particlesCount / maxParticles * 100;
    
}

int Receptor::getCount(){
    
    return (int) floor(particlesCount);
    
}

bool Receptor::isFilled(){
    
    return filled;
    
}

float Receptor::getDecreasingFactor(){
    
    return decreasingFactor;
    
}

int Receptor::getMaxParticles(){
    
    return maxParticles;
    
}