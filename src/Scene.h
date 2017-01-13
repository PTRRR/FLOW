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
    
    //-----------------------------------------
    
    //Game elements
    
    //Emitter
    
    vector<shared_ptr<ParticleSystem>> emitters;
    vector<shared_ptr<Particle>> allParticles;
    
    //Receptor
    
    bool allAreFilled = false;
    ofImage receptorImg;
    
    vector<shared_ptr<Receptor>> receptors;
    
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
    
    //Fixed actuators
    
    vector<shared_ptr<Actuator>> fixedActuators;
    
    //Polygones
    
    vector<shared_ptr<Polygone>> polygones;
    void checkForCollisions();
    
    //GPU rendering variables.
    
    //Quad texture
    
    ofShader quadTextureProgram;
    ofShader simpleQuadTextureProgram;
    
    //Emitters
    
    ofImage emitterImg;
    
    ofVbo emittersVbo;
    vector<ofVec3f> emittersVertices;
    vector<ofVec2f> emittersTexCoords;
    vector<ofIndexType> emittersIndices;
    
    //Particles
    
    ofImage particleImg;
    
    ofVbo particlesHeadVbo;
    vector<ofVec3f> positions;
    vector<ofVec3f> attributes;
    
    ofShader particleHeadProgram;
    ofShader particleTailProgram;
    
    //Tails
    
    ofVbo particlesTailVbo;
    vector<ofVec3f> tailPoints;
    vector<ofFloatColor> tailColors;
    vector<ofIndexType> tailIndices;
    vector<ofVec3f> baricentricCoords;
    
    void updateAllParticles();
    void updateParticlesRenderingData();
    
    //Receptors
    
    ofShader receptorProgram;
    
    ofVbo receptorsVbo;
    vector<ofVec3f> receptorsVertices;
    vector<ofVec2f> receptorsTexCoords;
    vector<ofIndexType> receptorsIndices;
    vector<ofVec3f> receptorsAttributes;
    
    //Actuators
    
    ofShader actuatorsProgram;
    
    ofVbo actuatorsVbo;
    vector<ofVec3f> actuatorsVertices;
    vector<ofVec2f> actuatorsTexCoords;
    vector<ofIndexType> actuatorsIndices;
    vector<ofVec3f> actuatorsAttributes;
    
    //Actuators ring
    
    ofImage actuatorArrowImg;
    
    ofVbo actuatorsRingVbo;
    vector<ofVec3f> actuatorsRingVertices;
    vector<ofVec2f> actuatorsRingTexCoords;
    vector<ofIndexType> actuatorsRingIndices;
    vector<ofFloatColor> actuatorsRingColors;
    
    void updateActuatorsRenderingData();
    
    //Polygones
    
    ofShader polygoneProgram;
    ofShader polygoneWireframeProgram;
    
    ofVbo polygonesVbo;
    vector<ofVec3f> polygonesVertices;
    vector<ofIndexType> polygonesIndices;
    vector<ofVec3f> polygonesAttributes;
    vector<ofFloatColor> polygoneVerticesColor;
    
    //Utils
    
    vector<ofVec3f> getQuadVertices(float _size);
    
    //User inputs callbacks
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
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
