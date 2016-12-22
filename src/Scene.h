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

#include "FlowField.h"
#include "BaseElement.h"
#include "ParticleSystem.h"
#include "Receptor.h"
#include "Particle.h"
#include "Magnet.h"

class Scene : public Screen{

private:
    
    //GUI
    Interface interface;
    
    //Main
    float time;
    void renderToFbo() override;
    
    //Emitter
    
    ParticleSystem particleSystem;
    
    //Receptor
    
    shared_ptr<Receptor> receptor;
    
    //Magnets
    
    static const int MAX_MAGNET_NUM = 10;
    vector<shared_ptr<Magnet>> magnets;
    
    shared_ptr<Magnet> currentMagnet = nullptr;
    ofVec2f currentMagnetTarget;
    
    //Utility to add some magnets to the scene and in the flow field
    
    void addMagnet(ofVec2f _position, float _strength, float _radiusOfAction);
    
    //Flow field
    
    shared_ptr<FlowField> flowField;
    
    //3D
//    CameraPersp camera;
    
    //Background shader -> draw the outlines of the magnetic field
//    gl::GlslProgRef backGroundShader;
//    void loadBackgroundShader();
//    void updateBackgroudShader();
    
    
    //User inputs callbacks
    void onMouseDown(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    void onMouseMove(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    void onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    void onMouseUp(ofVec2f _position, function<void(string _text, string _action)> _callback) override;
    
    //Other callbacks
    function<void()> levelEndCallback = nullptr;
    
public:
    
    Scene();
    Scene(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update() override;
    void onEnd(function<void()> _levelEndCallback);
    
    void XMLSetup();
    
};

#endif /* Scene_h */
