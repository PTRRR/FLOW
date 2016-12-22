//
//  Magnet.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#include "Magnet.h"

Magnet::Magnet(){};


void Magnet::setTarget(ofVec2f _target){
    
    target = _target;
    
}

void Magnet::setStrength(float _strength){
    
    strength = _strength;
    radius = 5.0f;
    radiusOfAction = 10.0f;
    target = position;
    
}

void Magnet::setRadiusOfAction(float _radiusOfAction){
    
    radiusOfAction = _radiusOfAction;
    
}

void Magnet::setRadius(float _radius){
    
    radius = _radius;
    
}

float Magnet::getStrength(){
    
    return strength;
    
}

float Magnet::getRadius(){
    
    return radius;
    
}

float Magnet::getRadiusOfAction(){
    
    return radiusOfAction;
    
}

void Magnet::debugDraw(){
    
    ofPushStyle();
    ofSetColor(255, 255, 255);
    ofNoFill();
    ofDrawCircle(position, radiusOfAction);
    ofFill();
    ofSetColor(255, 255, 255);
    ofDrawCircle(position, 20);
    ofPopStyle();
    
}