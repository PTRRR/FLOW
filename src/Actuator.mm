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
    radiusTarget = radius;
    
    overRadius = 50.0;

}

//Main

void Actuator::debugDraw(){
    
    ofPushStyle();
    
    ofNoFill();
    ofDrawCircle(getPosition() , radius);
    
    ofPopStyle();
    
}

void Actuator::update(){
    
    Actuator::BaseElement::update();
    
    //Interpolation
    
    radius += (radiusTarget - radius) * 0.2;
    
    radius = ofClamp(radius, 50, 400);

    
}

//Set

void Actuator::setStrength(float _strength){
    
    strength = _strength;
    
}

void Actuator::setRadius(float _radius){
    
    radiusTarget = _radius / (radius * 0.01);
    
}

void Actuator::enable(bool _enable){
    
    enabled = _enable;
    
}

void Actuator::setOverRadius(float _overRadius){
    
    overRadius = _overRadius;
    
}

//Get

ofVec2f Actuator::getForceAtPoint(ofVec2f _position){
    
    if(!enabled) return ofVec2f(0);
    
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

bool Actuator::getEnabled(){
    
    return enabled;
    
}