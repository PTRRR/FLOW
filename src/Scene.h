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
#include "Text.h"

#include "VboLine.h"
#include "BaseElement.h"
#include "ParticleSystem.h"
#include "Receptor.h"
#include "Particle.h"
#include "Actuator.h"
#include "Polygone.h"
#include "ofxXmlSettings.h"
#include "ofxOpenALSoundPlayer.h"
#include <locale>
#include <algorithm>

#import "AVSoundPlayer.h"

class Scene : public Screen{
    
protected:
    
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
    
    //Hack
    
    bool activateActuatorResize = false;
    float finishTimer = 0;
    float timeToFinish = 6;
    float congratulationTextAlpha = 0.0f;
    shared_ptr<Text> congratulationText;
    shared_ptr<Text> congratulationText2;
    bool end = false;
    
    string title;
    shared_ptr<Text> levelTitle;
    
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
    
    vector<shared_ptr<Actuator>> actuators;
    vector<shared_ptr<Actuator>> activeActuators;
    
    //Fixed actuators
    
    vector<shared_ptr<Actuator>> fixedActuators;
    
    //Polygones
    
    vector<shared_ptr<Polygone>> polygones;
    void checkForCollisions();
    shared_ptr<ofVec2f> getIntersection(ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4);
    bool segmentIntersection(ofVec2f _intersection, ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4);
    
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
    vector<ofFloatColor> emittersColors;
    
    void updateEmitterRenderingData();
    
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
    
    ofShader linesProgram;
    VboLine receptorStatusLines;
    
    ofShader receptorProgram;
    
    ofVbo receptorsVbo;
    vector<ofVec3f> receptorsVertices;
    vector<ofVec2f> receptorsTexCoords;
    vector<ofIndexType> receptorsIndices;
    vector<ofFloatColor> receptorsColors;
    vector<ofVec3f> receptorsAttributes;
    
    ofImage particleReceptionFeedbackImg;
    ofVbo particleReceptionFeedbackVbo;
    vector<ofVec3f> particleReceptionFeedbackVertices;
    vector<ofVec3f> particleReceptionFeedbackAttributes;

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
    
    //Actuators lines
    
    VboLine actuatorsLines;
    
    void updateActuatorsRenderingData();
    
    //Polygones
    
    ofImage polygoneImg;
    
    ofShader polygoneProgram;
    ofShader polygoneWireframeProgram;
    
    ofVbo polygonesVbo;
    vector<ofVec3f> polygonesVertices;
    vector<ofIndexType> polygonesIndices;
    vector<ofVec2f> polygonesTexCoords;
    vector<ofVec3f> polygonesAttributes;
    vector<ofFloatColor> polygoneVerticesColor;
    
    //Polygone rendering test
    
    ofImage dashedPolygoneImg;
    ofShader dashedPolygoneProgram;
    
    ofVbo dashedPolygonesVbo;
    vector<ofVec3f> dashedPolygonesVertices;
    vector<ofVec3f> dashedPolygonesAttributes;
    
    //Utils
    
    vector<ofVec3f> getQuadVertices(float _size);
    
    //User inputs callbacks
    
    bool db = false;
    
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
    //Other callbacks
    
    function<void()> levelEndCallback = nullptr;
    
    //Sounds
    
    float lastPlay = 0;
    float playOffset = 100.0;
    ofSoundPlayer hitSound;
    
    //XML files
    
    void saveSceneToXML(string _fileName);
    virtual void setup(){};
    
public:
    
    Scene();
    Scene(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update() override;
    void updateSound() override;
    void initializeGPUData();
    void setPause(bool _pause);
    void onEnd(function<void()> _levelEndCallback);
    
    bool isFinished();
    string getTitle();
    void XMLSetup(string _xmlFile, string _name);
    
};

#endif /* Scene_h */
