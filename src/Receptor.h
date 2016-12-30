//
//  Receptor.h
//  ofMagnet
//
//  Created by Pietro Alberti on 30.12.16.
//
//

#ifndef Receptor_h
#define Receptor_h

#include <stdio.h>
#include "Actuator.h"

class Receptor : public Actuator {

private:
    
    float particlesCount = 0;
    float decreasingFactor = 0.022;
    
    float maxParticles = 300;
    
public:

    Receptor();
    
    void update();
    void debugDraw();
    
    //Set
    
    void addOneParticleToCount();
    
    //Get
    
    float getPercentFill();
    int getCount();
    
};

#endif /* Receptor_h */
