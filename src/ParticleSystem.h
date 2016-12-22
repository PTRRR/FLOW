//
//  ParticleSystem.h
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#ifndef ParticleSystem_h
#define ParticleSystem_h

#include <stdio.h>
#include "FlowField.h"
#include "BaseElement.h"
#include "Particle.h"

class ParticleSystem : public BaseElement{

private:
    
    //These variables will be usefull to add particles according to a precise rate.
    
    float currentTime = 0.0f; //ms
    float lastTime = 0.0f; //ms
    float deltatime = 0.0f; //ms
    float elapsedTime = 0.0f; //ms
    
    //The updateRate varable defines the rate the emitter will update the number of particle.
    //(milliseconds)
    
    float updateRate = 10;
    
    //The emissionRate variable defines how much particles will be emmitted per second.
    //(particles per seconds)
    
    float toEmit = 0.0f;
    float emissionRate = 10;
    
    //Settings
    int nParticles = 1;
    int maxParticles = 100;
    
    //Apperance
    
    //Emitter object
//    gl::BatchRef        mRect;
//    gl::GlslProgRef		mGlsl;
    
    float radius;
    vector<shared_ptr<Particle>> particles;
    
    int updateTime = 100; //ms
    
public:
    
    ParticleSystem();
    
    //Initialize the emitter after setting properties
    void initialize();
    void display();
    void update();
    
    //Control
    void addParticles(int num);
    
    //Set
    void setRadius(float _radius);
    void setEmissionRate(float _emissionRate);
    void applyForceToParticles(ofVec2f _force);
    void applyForceToParticles(shared_ptr<FlowField> _flowField);
    
    void removeParticle(shared_ptr<Particle> _particle);
    vector<shared_ptr<Particle>> getParticles();
    
    
    //Get
    float getRadius();
    float getEmissionRate();
    
};

#endif /* ParticleSystem_h */
