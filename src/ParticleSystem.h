//
//  ParticleSystem.h
//  particleSystem
//
//  Created by Pietro Alberti on 24.12.16.
//
//

#ifndef ParticleSystem_h
#define ParticleSystem_h

#include <stdio.h>
#include "BaseElement.h"
#include "Particle.h"
#include "Actuator.h"
#include "Receptor.h"

class ParticleSystem : public BaseElement{

private:
    
    ofVec2f boxSize;
    
    float rate;
    float updateRate;
    float elapsedTime;
    float toEmit;
    int maxParticles;
    
    vector<shared_ptr<Particle>> particles;
    vector<shared_ptr<Actuator>> actuators;
    vector<shared_ptr<Receptor>> receptors;
    
public:

    ParticleSystem();
    
    //Main
    
    void init();
    void debugDraw();
    void update();
    void applyGravity(ofVec2f _gravity);
    void applyForce(ofVec2f _force);
    void addParticles(int _num);
    void removeParticle(int _index);
    void addActuator(shared_ptr<Actuator> _actuator);
    void addReceptor(shared_ptr<Receptor> _receptor);
    void removeActuator(shared_ptr<Actuator> _actuator);
    
    //Set
    
    void setBoxSize(ofVec2f _boxSize);
    void setRate(float _rate);
    void empty();
    void setMaxParticles(int _maxParticles);
    
    //Get
    
    vector<shared_ptr<Particle>> getParticles();
    float getRate();
    int getMaxParticles();
    
};

#endif /* ParticleSystem_h */
