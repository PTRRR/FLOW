//
//  Actuator.mm
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#include "Actuator.h"

Actuator::Actuator(){

    strength = 0.0;
    radius = 100.0;
    
    overRadius = 50.0;

}

//Main

void Actuator::debugDraw(){
    
    ofPushStyle();
    
    ofDrawCircle(getPosition(), 20);
    ofNoFill();
    ofDrawCircle(getPosition() , radius);
    
    ofPopStyle();
    
}

//Set

void Actuator::setStrength(float _strength){
    
    strength = _strength;
    
}

void Actuator::setRadius(float _radius){
    
    radius = _radius;
    
}

//Get

ofVec2f Actuator::getForceAtPoint(ofVec2f _position){
    
    ofVec2f force = ofVec2f(0);
    ofVec2f direction = getPosition() - _position;
    float distance = direction.length();
    
    if(distance > radius) return ofVec2f(0);
    
    float percent = 1 - (distance / radius);
    percent = ofClamp(percent, 0.0f, 1.0f);
    
    force = direction.normalize() * strength * percent;
    
    return force;
    
}

bool Actuator::isOver(ofVec2f _position){
    
    float distance = (getPosition() - _position).length();
    return distance <= overRadius;
    
}

float Actuator::getStrength(){
    
    return strength;
    
}

float Actuator::getRadius(){
    
    return radius;
    
}