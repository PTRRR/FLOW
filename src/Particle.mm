//
//  Particle.mm
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#include "Particle.h"

Particle::Particle(){

    numPoints = floor(ofRandom(10));
    circleDefinition = floor(ofRandom(5) + 3);

}

void Particle::update(){
    
    Particle::BaseElement::update();
    
    lifeLeft -= getDeltatime();
    
}

void Particle::debugDraw(){
    
    ofPushStyle();
    ofFill();
    ofSetColor(255, 255, 255, lifeLeft / lifeSpan * 255);
    ofPushMatrix();
    ofTranslate(getPosition());
    ofRotate(ofRadToDeg(getAngle()));
    ofDrawCircle(ofVec2f(0), getMass() * 5.0);
    ofPopMatrix();
    ofPopStyle();
    
}

//Set

void Particle::setNumPoints(int _num){
    
    numPoints = _num;
    
}

void Particle::setLifeSpan(float _lifeSpan){
    
    lifeSpan = _lifeSpan;
    lifeLeft = _lifeSpan;
    
}

//Get

float Particle::getAngle(){
    
    return atan2(getVelocity().y, getVelocity().x);
    
}

int Particle::getNumPoints(){
    
    return numPoints;
    
}

float Particle::getLifeSpan(){
    
    return lifeSpan;
    
}

float Particle::getLifeLeft(){
    
    return lifeLeft;
    
}

vector<ofVec2f> Particle::getPoints(){
    
    return points;
    
}

bool Particle::isDead(){
    
    return lifeLeft <= 0.0;
    
}