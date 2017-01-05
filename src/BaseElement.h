//
//  BaseElement.h
//  particleSystem
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#ifndef BaseElement_h
#define BaseElement_h

#include <stdio.h>
#include "ofxiOS.h"

class BaseElement {
    
private:
    
    ofVec2f lastPosition;
    ofVec2f position;
    ofVec2f nextPosition;
    ofVec2f velocity;
    ofVec2f acceleration;
    
    float mass;
    float damping;
    
    float maxVelocity;
    
    //Box
    //If set, this box restrict the movements of the object in that box
    
    ofVec4f box;
    bool out;
    
    //Time variables
    
    float lastTime;
    float deltaTime;
    float targetDeltaTime = 1000.0 / 60.0;
    
protected:
    
    bool disabled;
    float getDeltatime();
    
public:
    
    BaseElement();
    
    //Main
    
    void update();
    
    //Set
    
    void setPosition(ofVec2f _position);
    void setVelocity(ofVec2f _velocity);
    void setAcceleration(ofVec2f _acceleration);
    
    void setMass(float _mass);
    void setDamping(float _damping);
    void setMaxVelocity(float _maxVelocity);
    void setBox(float _x, float _y, float _width, float _height);
    
    void disable(bool _disable);
    
    //Get
    
    ofVec2f getLastPosition();
    ofVec2f getPosition();
    ofVec2f getNextPosition();
    ofVec2f getVelocity();
    ofVec2f getAcceleration();
    
    float getMass();
    float getDamping();
    
    bool isOut();
    
    //Physics
    
    void applyForce(ofVec2f _force);
    
};

#endif /* BaseElement_h */
