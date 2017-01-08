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
#include "ofxOpenALSoundPlayer.h"

class Scene : public Screen{

private:
    
    //Level
    
    ofxXmlSettings XML;
    
    //Main
    
    bool IS_PAUSED = false;
    int ORIGINAL_WIDTH = ofGetWidth();
    int ORIGINAL_HEIGHT = ofGetHeight();
    int MAX_PARTICLES = 1000;
    int MAX_TAIL_LENGTH = 10;
    int MAX_ACTUATORS_NUM = 3;
    
    vector<ofVec2f> touches;
    float time;
    void renderToScreen() override;
    
    //GUI
    
    Interface interface;
    
    //Emitter

    vector<shared_ptr<ParticleSystem>> emitters;
    vector<shared_ptr<Particle>> allParticles;
    
    void updateAllParticles();
    
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
    
    //Receptor
    
    vector<shared_ptr<Receptor>> receptors;
    
    //Actuators

    ofRectangle actuatorBox;
    
    ofImage actuatorImg;
    
    vector<shared_ptr<Actuator>> actuators;
    vector<shared_ptr<Actuator>> activeActuators;
    
    void updatePolygonesRenderingData();
    
    //Fixed actuators
    
    vector<shared_ptr<Actuator>> fixedActuators;
    
    //Polygones
    
    vector<shared_ptr<Polygone>> polygones;
    void checkForCollisions();
    
    //Polygones rendering
    
    ofVbo polygonesVbo;
    vector<ofVec3f> polygonesVertices;
    vector<ofIndexType> polygonesIndices;
    vector<ofFloatColor> polygoneVerticesColor;
    
    //User inputs callbacks
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    
    //Other callbacks
    function<void()> levelEndCallback = nullptr;
    
    //Sounds

    
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
    void setPause(bool _pause);
    void onEnd(function<void()> _levelEndCallback);
    
    void XMLSetup(string _xmlFile);
    
};

#endif /* Scene_h */
