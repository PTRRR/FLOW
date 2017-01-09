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
    
    ofTrueTypeFont infosFont;
    
    bool IS_FINISHED = false;
    bool IS_PAUSED = false;
    int ORIGINAL_WIDTH = ofGetWidth();
    int ORIGINAL_HEIGHT = ofGetHeight();
    int MAX_PARTICLES = 1000;
    int MAX_TAIL_LENGTH = 10;
    int MAX_ACTUATORS_NUM = 3;
    
    vector<ofVec2f> touches;
    float time = 0;
    void renderToScreen() override;
    
    //GUI
    
    ofImage backButtonImg;
    ofImage optionsButtonImg;
    Interface interface;
    
    //Emitter
    
    ofImage emitterImg;

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
    vector<ofVec3f> baricentricCoords;
    
    void updateParticlesRenderingData();
    
    //Receptor
    
    bool allAreFilled = false;
    ofImage receptorImg;
    
    vector<shared_ptr<Receptor>> receptors;
    
    ofShader receptorProgram;
    
    ofVbo receptorsVbo;
    vector<ofVec3f> receptorsVertices;
    vector<ofVec2f> receptorsTexCoords;
    vector<ofIndexType> receptorsIndices;
    vector<ofFloatColor> receptorsColors;
    vector<ofVec3f> receptorsAttributes;
    
    void updateReceptorsRenderingData();
    
    //Actuators

    ofRectangle actuatorBox;
    
    ofImage actuatorImg;
    ofImage activeActuatorImg;

    //How much time the user have to stay still until he update the radius of the actuator.
    
    float timeToChange = 1200;
    vector<float> actuatorsTimer;
    
    vector<shared_ptr<Actuator>> actuators;
    vector<shared_ptr<Actuator>> activeActuators;
    
    ofShader actuatorsProgram;
    
    ofVbo actuatorsVbo;
    vector<ofVec3f> actuatorsVertices;
    vector<ofVec2f> actuatorsTexCoords;
    vector<ofIndexType> actuatorsIndices;
    vector<ofFloatColor> actuatorsColors;
    vector<ofVec3f> actuatorsAttributes;
    
    void updateActuatorsRenderingData();
    
    //Fixed actuators
    
    vector<shared_ptr<Actuator>> fixedActuators;
    
    //Polygones
    
    void updatePolygonesRenderingData();
    
    vector<shared_ptr<Polygone>> polygones;
    void checkForCollisions();
    
    //Polygones rendering
    
    ofShader polygoneProgram;
    ofShader polygoneWireframeProgram;
    
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

    void saveSceneToXML(string _fileName);
    
public:
    
    Scene();
    Scene(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update() override;
    void initializeGPUData();
    void setPause(bool _pause);
    void onEnd(function<void()> _levelEndCallback);
    
    bool isFinished();
    
    void XMLSetup(string _xmlFile);
    
};

#endif /* Scene_h */
