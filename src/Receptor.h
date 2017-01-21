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
    
    float particleReceptionFeedbackRadius = 0.0;
    
    float maxParticles = 300;
    
    bool filled = false;
    
public:

    Receptor();
    
    void update();
    void debugDraw();
    
    //Set
    
    void addOneParticleToCount();
    void setDecreasingFactor(float _decreasingFactor);
    void setMaxParticles(int _maxParticles);
    
    //Get
    
    float getPercentFill();
    int getCount();
    bool isFilled();
    float getDecreasingFactor();
    int getMaxParticles();
    float getParticleReceptionFeedbackRadius();
    
    
};

#endif /* Receptor_h */
