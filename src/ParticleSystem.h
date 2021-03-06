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

#import "AVSoundPlayer.h"

class ParticleSystem : public BaseElement{

private:
    
    bool paused;
    
    ofVec2f boxSize;
    
    float rate;
    float updateRate;
    float elapsedTime;
    float toEmit;
    int maxParticles;
    int maxTailLength;
    
    vector<shared_ptr<Particle>> particles;
    vector<shared_ptr<Actuator>> actuators;
    vector<shared_ptr<Receptor>> receptors;
    
    //GPUDraw
    //Head
    
    ofVbo particlesHeadVbo;
    vector<ofVec3f> positions;
    vector<ofVec3f> attributes;
    
    //Tail
    
    ofVbo particlesTailVbo;
    vector<ofVec3f> tailPoints;
    vector<ofFloatColor> tailColors;
    vector<ofIndexType> tailIndices;
    
    float mainVolume = 0.0;
    float receptionSoundVolume = 0.0;
    ofSoundPlayer receptionSound;
    vector<ofSoundPlayer> sounds;
    
public:

    ParticleSystem();
    ~ParticleSystem();
    
    //Main
    
    void reset();
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
    void setMaxTailLength(int _length);
    void setPause(bool _pause);
    void setMainVolume(float _mainVolume);
    
    //Get
    
    vector<shared_ptr<Particle>> getParticles();
    float getRate();
    int getMaxParticles();
    ofVec2f getBoxSize();
    int getMaxTailLength();
    
};

#endif /* ParticleSystem_h */
