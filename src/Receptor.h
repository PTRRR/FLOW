//
//  Receptor.h
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#ifndef Receptor_h
#define Receptor_h

#include <stdio.h>
#include "Magnet.h"
#include "Particle.h"

class Receptor : public Magnet {
    
private:
    
    int count;
    float radius;
    vector<Particle> particles;
    
public:
    
    Receptor();
    
    void display();
    
    //Set
    void setPosition(ofVec2f _position);
    void setRadius(float _radius);
    void setCount(int _count);
    
    //Get
    int getCount();
    float getRadius();
    
};

#endif /* Receptor_h */
