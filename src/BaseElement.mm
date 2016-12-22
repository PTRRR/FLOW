//
//  BaseElement.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "BaseElement.h"

BaseElement::BaseElement(){
    
    position = ofVec2f(0);
    lastPos = ofVec2f(0);
    velocity = ofVec2f(0);
    acceleration = ofVec2f(0);
    mass = 1;
//    boundingBox.zero();
    
    
};

void BaseElement::update(){
    
    velocity *= 0.99f;
    velocity += acceleration / mass;
    
//    if(glm::length(velocity) > maxSpeed){
//        velocity = glm::normalize(velocity) * maxSpeed;
//    }
    
    setPosition(position + velocity);
    
    acceleration *= 0;
    
    
}

void BaseElement::updateIsOut(){
    
//    if (boundingBox.calcArea() > 0) {
//        
//        if (position.x >= boundingBox.getX1() && position.x <= boundingBox.getX2() && position.y >= boundingBox.getY1() && position.y <= boundingBox.getY2()) {
//            out = false;
//        }else{
//            out = true;
//        }
//        
//    }
    
}

//Set
void BaseElement::setPosition(ofVec2f _position){
    
    lastPos = this->position;
    position = _position;
    
    updateIsOut();
    
//    if(limit && isOut()){
//        
//        if(this->position.x > boundingBox.x2) this->position.x = boundingBox.x2;
//        if(this->position.x < boundingBox.x1) this->position.x = boundingBox.x1;
//        if(this->position.y > boundingBox.y2) this->position.y = boundingBox.y2;
//        if(this->position.y < boundingBox.y1) this->position.y = boundingBox.y1;
//        
//        out = false;
//        
//    }
    
}

void BaseElement::setVelocity(ofVec2f _velocity){
    
    velocity = _velocity;
    
}

void BaseElement::setMaxVelocity(float _maxVelocity){
    
    maxSpeed = _maxVelocity;
    
}

void BaseElement::setMass(float _mass){
    
    mass = _mass;
    
}

void BaseElement::applyForce(ofVec2f _force){
    
    acceleration += _force;
    
}

//void BaseElement::setBoundingBox(Rectf _boundingBox){
//    
//    boundingBox = _boundingBox;
//    
//}

void BaseElement::setLimitToBoundingBox(bool _limit){
    
    limit = _limit;
    
}

//Get
ofVec2f BaseElement::getPosition(){
    
    return this->position;
    
}

ofVec2f BaseElement::getLastPos(){
    
    return lastPos;
    
}

ofVec2f BaseElement::getVelocity(){
    
    return this->velocity;
    
}

float BaseElement::getMass(){
    
    return mass;
    
}

bool BaseElement::isOut(){
    
    return out;
    
}
