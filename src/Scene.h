//
//  Scene.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef Scene_h
#define Scene_h

#include <stdio.h>
#include "Screen.h"
#include "Interface.h"
#include "Button.h"

#include "BaseElement.h"
#include "ParticleSystem.h"
#include "Receptor.h"
#include "Particle.h"
#include "Actuator.h"
#include "Polygone.h"

class Scene : public Screen{

private:
    
    //Main
    
    ofVec2f touchPos;
    float time;
    void renderToScreen() override;
    
    //GUI
    
    Interface interface;
    
    //Emitter
    
    const int MAX_PARTICLES = 1500;
    ParticleSystem particleSystem;
    
    //Receptor
    
    vector<shared_ptr<Receptor>> receptors;
    
    //Actuators
    
    static const int MAX_MAGNET_NUM = 10;
    vector<shared_ptr<Actuator>> actuators;
    shared_ptr<Actuator> activeActuator;
    
    //Polygones
    
    vector<shared_ptr<Polygone>> polygones;
    void checkForCollisions();
    
    //User inputs callbacks
    void onMouseDown(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    void onMouseMove(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    void onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    void onMouseUp(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    
    //Other callbacks
    function<void()> levelEndCallback = nullptr;
    
    //Particles rendering
    
    ofImage particleImg;
    
    ofVbo particlesHeadVbo;
    vector<ofVec3f> positions;
    vector<ofVec3f> attributes;
    
    ofShader particleHeadProgram;
    
    void updateParticlesRendering();
    
public:
    
    Scene();
    Scene(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update() override;
    void initialize();
    void onEnd(function<void()> _levelEndCallback);
    
    void XMLSetup();
    
};

#endif /* Scene_h */
