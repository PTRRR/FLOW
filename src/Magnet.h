//
//  Magnet.h
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#ifndef Magnet_h
#define Magnet_h

#include <stdio.h>
#include "BaseElement.h"

class Magnet : public BaseElement {
    
private:
    
    float strength;
    float radius;
    float radiusOfAction;
    
    ofVec2f target;
    
public:
    
    Magnet();
    
    void debugDraw();
    
    //Set
    void setStrength(float _strength);
    void setRadius(float _radius);
    void setRadiusOfAction(float _radiusOfAction);
    void setTarget(ofVec2f _target);
    
    //Get
    float getStrength();
    float getRadius();
    float getRadiusOfAction();
    
};

#endif /* Magnet_h */
