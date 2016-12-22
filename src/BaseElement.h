//
//  BaseElement.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef BaseElement_h
#define BaseElement_h

#include <stdio.h>
#include "ofxiOS.h"

class BaseElement {

private:
    
protected:
    
    ofVec2f position;
    ofVec2f lastPos;
    ofVec2f velocity;
    ofVec2f acceleration;
    
    float mass;
    float damping;
    
    float maxSpeed = 3;
    
    float lifeSpan = 100;
    
//    Rectf boundingBox;
    bool limit = false;
    bool out = false;
    
    void updateIsOut();
    
public:
    
    BaseElement();
    
    void update();
    
    //Set
    void setPosition(ofVec2f _position);
    void setVelocity(ofVec2f _velocity);
    void setMass(float _mass);
    void setMaxVelocity(float _maxVelocity);
    void applyForce(ofVec2f _force);
    
//    void setBoundingBox(Rectf _boundingBox);
    void setLimitToBoundingBox(bool _limit);
    
    //Get
    ofVec2f getPosition();
    ofVec2f getLastPos();
    ofVec2f getVelocity();
    float getMass();
    bool isOut();
    
};

#endif /* BaseElement_h */
