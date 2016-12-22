//
//  Particle.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#include "Particle.h"

Particle::Particle(){
    
    headDefinition = floor(ofRandomf() * 3.0f + 3.0f);
    maxPoints = floor(ofRandomf() * 50.0f + 20.0f);
    time = ofGetElapsedTimeMillis();
    lastTime = time;
    lifeSpan = ofRandomf() * 10000.0f + 2000.0f;
    totalLife = lifeSpan;
    dead = false;
    
};

void Particle::display(){
    
    ofPushMatrix();
    ofTranslate(position);
    ofRotate(angle);
    ofDrawCircle(ofVec2f(0), mass * 0.4f + 1.5f);
    ofPopMatrix();
    
}

void Particle::update(){
    
    if(!isDead()){
        
        time += (ofGetElapsedTimeMillis()) - lastTime;
        
        Particle::BaseElement::update();
        
        applyForce(ofVec2f(ofRandomf() - 0.5f, ofRandomf() - 0.5f) * 0.1f);
        
        //Update lifespan
        
        if(lifeSpan > 0){
            lifeSpan -= time - lastTime;
        }else{
            dead = true;
        }
        
        angle = atan2(velocity.y, velocity.x);
        
        if(points.size() <= maxPoints){
            points.push_back(position);
        }else{
            points.erase(points.begin());
            points.push_back(position);
        }
        
        lastTime = time;
        
    }
    
}

float Particle::getLifeSpan(){
    
    return lifeSpan;
    
}

float Particle::getTotalLife(){
    
    return totalLife;
    
}

bool Particle::isDead(){
    
    return dead;
    
}

vector<ofVec2f> Particle::getPoints(){
    
    return points;
    
}