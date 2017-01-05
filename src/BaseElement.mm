//
//  BaseElement.mm
//  particleSystem
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#include "BaseElement.h"

BaseElement::BaseElement(){
    
    disabled = false;
    
    position = ofVec2f(0);
    velocity = ofVec2f(0);
    acceleration = ofVec2f(0);
    
    mass = 1.0;
    damping = 0.99;
    
    maxVelocity = 1;
    
    //Box
    
    box = ofVec4f(0);
    
    //Time variables
    
    lastTime = ofGetElapsedTimeMillis();
    deltaTime = 0;
    
}

//Main

void BaseElement::update(){
    
    deltaTime = ofGetElapsedTimeMillis() - lastTime;
     
    //Scale the physics calculations according to the frame rate
    
    float FPSScaleFactor = deltaTime / targetDeltaTime;
    
    if(!disabled){
     
        velocity += acceleration * FPSScaleFactor;
        velocity = velocity.limit(maxVelocity);
        velocity *= damping;
        
        lastPosition = position;
        position += velocity * FPSScaleFactor;
        nextPosition = position + velocity * FPSScaleFactor;
        
        //Check if box is set
        
        float boxArea = box.z * box.w;
        
        if(position.x < box.x || position.x > box.x + box.z || position.y < box.y || position.y > box.y + box.w){
            out = true;
        }else{
            out = false;
        }
        
        if(boxArea > 0){
            
            position.x = ofClamp(position.x, box.x, box.x + box.z);
            position.y = ofClamp(position.y, box.y, box.y + box.w);
            
        }
        
        //Reset
        
        acceleration *= 0;
        
    }
    
    lastTime = ofGetElapsedTimeMillis();
    
}

//Set

void BaseElement::setPosition(ofVec2f _position){
    
    position = _position;
    
}

void BaseElement::setVelocity(ofVec2f _velocity){
    
    velocity = _velocity;
    
}

void BaseElement::setAcceleration(ofVec2f _acceleration){
    
    acceleration = _acceleration;
    
}

void BaseElement::setMass(float _mass){
    
    mass = ofClamp(_mass, 1.0, 1000.0);
    
}

void BaseElement::setDamping(float _damping){
    
    damping = ofClamp(_damping, 0.0, 1.0);
    
}

void BaseElement::setMaxVelocity(float _maxVelocity){
    
    maxVelocity = _maxVelocity;
    
}

void BaseElement::setBox(float _x, float _y, float _width, float _height){

    box.x = _x;
    box.y = _y;
    box.z = _width;
    box.w = _height;
    
}

void BaseElement::disable(bool _disable){
    
    disabled = _disable;
    
}

//Get protected

float BaseElement::getDeltatime(){
    
    return deltaTime;
    
}

//Get

ofVec2f BaseElement::getLastPosition(){
    
    return lastPosition;
    
}

ofVec2f BaseElement::getPosition(){
    
    return position;
    
}

ofVec2f BaseElement::getNextPosition(){
    
    return nextPosition;
    
}

ofVec2f BaseElement::getVelocity(){
    
    return velocity;
    
}

ofVec2f BaseElement::getAcceleration(){
    
    return acceleration;
    
}

float BaseElement::getMass(){
    
    return mass;
    
}

float BaseElement::getDamping(){
    
    return damping;
    
}

bool BaseElement::isOut(){
    
    return out;
    
}


//Physics

void BaseElement::applyForce(ofVec2f _force){
    
    if(disabled) return;
    
    acceleration += _force / mass;
    
}