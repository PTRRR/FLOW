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
#include "ofxXmlSettings.h"

class Scene : public Screen{

private:
    
    //Level
    
    ofxXmlSettings XML;
    
    //Main
    
    int ORIGINAL_WIDTH = ofGetWidth();
    int ORIGINAL_HEIGHT = ofGetHeight();
    int MAX_PARTICLES = 1000;
    int MAX_TAIL_LENGTH = 10;
    int MAX_ACTUATORS_NUM = 3;
    
    ofVec2f touchPos;
    float time;
    void renderToScreen() override;
    
    //GUI
    
    Interface interface;
    
    //Emitter

    vector<shared_ptr<ParticleSystem>> emitters;
    vector<shared_ptr<Particle>> allParticles;
    
    void updateAllParticles();
    
    //Receptor
    
    vector<shared_ptr<Receptor>> receptors;
    
    //Actuators

    vector<shared_ptr<Actuator>> actuators;
    shared_ptr<Actuator> activeActuator;
    
    //Fixed actuators
    
    vector<shared_ptr<Actuator>> fixedActuators;
    
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
    //Head
    //This variables are related to the rendering of the head of the particle
    
    ofImage particleImg;
    
    ofVbo particlesHeadVbo;
    vector<ofVec3f> positions;
    vector<ofVec3f> attributes;
    
    ofShader particleHeadProgram;
    ofShader particleTailProgram;
    
    //Tail
    
    ofVbo particlesTailVbo;
    vector<ofVec3f> tailPoints;
    vector<ofFloatColor> tailColors;
    vector<ofIndexType> tailIndices;
    
    void updateParticlesRenderingData();
    
    //XML files
    
    void loadXML(string _xmlFile, function<void(ofxXmlSettings _XML)> _callback);
    void saveXML(string _xmlFile, ofxXmlSettings _XML);
    void logXML(string _fileName);
    void saveSceneToXML(string _fileName);
    
public:
    
    Scene();
    Scene(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update() override;
    void initializeGPUData();
    void onEnd(function<void()> _levelEndCallback);
    
    void XMLSetup(string _xmlFile);
    
};

#endif /* Scene_h */
