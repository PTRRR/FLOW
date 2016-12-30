//
//  Particle.h
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#ifndef Particle_h
#define Particle_h

#include <stdio.h>
#include "ofxiOS.h"
#include "BaseElement.h"

class Particle : public BaseElement{
    
    
    int circleDefinition;
    
    int numPoints;
    vector<ofVec2f> points;
    
    float lifeSpan;
    float lifeLeft;
    bool dead;
    
public:
    
    Particle();
    
    void update();
    void debugDraw();
    
    //Set
    
    void setNumPoints(int _num);
    void setLifeSpan(float _lifeSpan);
    
    //Get
    
    float getAngle();
    int getNumPoints();
    float getLifeSpan();
    float getLifeLeft();
    
    vector<ofVec2f> getPoints();
    
    bool isDead();
    
};

#endif /* Particle_h */
