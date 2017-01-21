//
//  TestScene.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef TestScene_h
#define TestScene_h

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
#include "VboLine.h"

class TestScene : public Screen{
    
private:
    
    //Main
    
    shared_ptr<ofTrueTypeFont> mainFont;
    
    //Elements
    
    vector<ofVec2f> beforeImpact;
    vector<ofVec2f> impacts;
    vector<ofVec2f> inside;
    
    vector<shared_ptr<Particle>> particles;
    void addParticle();
    
    
    shared_ptr<Particle> particle;
    Polygone polygone;
    
    //Rendering
    
    void renderToScreen() override;
    
    //Collision
    
    shared_ptr<ofVec2f> getIntersection(ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4);
    
    //User inputs
    
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    void onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
public:
    
    TestScene();
    TestScene(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update() override;

    
};

#endif /* TestScene_h */
