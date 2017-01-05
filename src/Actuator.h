//
//  Actuator.h
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#ifndef Actuator_h
#define Actuator_h

#include <stdio.h>
#include "BaseElement.h"

class Actuator : public BaseElement{

private:
    
    bool enabled = true;
    
    float strength;
    float radius;
    
    float overRadius;
    
public:
    
    Actuator();
    
    //Main
    
    void debugDraw();
    
    //Set
    
    void setStrength(float _strength);
    void setRadius(float _radius);
    void enable(bool _enable);
    void setOverRadius(float _overRadius);
    
    //Get
    
    ofVec2f getForceAtPoint(ofVec2f _position);
    bool isOver(ofVec2f _position);
    float getStrength();
    float getRadius();
    bool getEnabled();
    
};

#endif /* Actuator_h */
