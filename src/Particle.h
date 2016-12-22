//
//  Particle.h
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#ifndef Particle_h
#define Particle_h

#include <stdio.h>
#include "BaseElement.h"

class Particle : public BaseElement{

    int headDefinition;
    
    int maxPoints = 70;
    float angle = 0.0f;
    vector<ofVec2f> points;
    
    float time;
    float lastTime;
    float totalLife;
    float lifeSpan;
    bool dead;
    
public:
    
    Particle();
    
    void display();
    void update();
    bool isDead();
    
    float getLifeSpan();
    float getTotalLife();
    
    vector<ofVec2f> getPoints();
    
};

#endif /* Particle_h */
