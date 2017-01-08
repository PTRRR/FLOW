//
//  Particle.mm
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#include "Particle.h"

Particle::Particle(){

    //Initialize some variables
    
    updateRate = 3;
    numPoints = 20;
    points = vector<ofVec2f>(numPoints, getPosition());
    
    //This is for debug draw
    
    circleDefinition = floor(ofRandom(5) + 3);
    
    dead = false;

}

Particle::Particle(ofVec2f _position){
    
    setPosition(_position);
    
    //Initialize some variables
    
    updateRate = 1; //More hight is the update rate longer will be the tail
    numPoints = 10;
    points = vector<ofVec2f>(numPoints, getPosition());
    
    //This is for debug draw
    
    circleDefinition = floor(ofRandom(5) + 3);
    
    dead = false;
    
}

void Particle::update(){
    
    //Here we update the base element of the particle. This will take care of all the movements,
    //physics, etc...
    
    Particle::BaseElement::update();
    
    if(disabled) return;
    
    //Update tail.
    //This takes care off adding points to the array of points composing the tail.
    //They can then be accessed by the function getPoints().
    //A point is added every n frames defined by the updateRate variable. Not every frame to speed up
    //the rendering time.
    
    if(ofGetFrameNum() % updateRate == 0){
     
        points.erase(points.begin());
        points.push_back(ofVec2f(getPosition().x + ofRandomf() * 1.9, getPosition().y));
        
    }
    
    //Update the tifespan to make the particle die. getDeltaTime is computed by the base element.
    
    lifeLeft -= getDeltatime();
    
}

//This function is used for quickly displaying the particle. Do not use for efficient rendering

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
    points = vector<ofVec2f>(numPoints, getPosition());
    
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