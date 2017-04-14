//
//  TutorialScene.h
//  ofMagnet
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#ifndef TutorialScene_h
#define TutorialScene_h

#include <stdio.h>
#include "Scene.h"

class TutorialScene : public Scene{
    
private:
    
    int tutorialStep = 0;
    
    float time = 0;
    float elapsedTime = 0;
    float lastTime = 0;
    
    shared_ptr<ofTrueTypeFont> textFont;
    Interface tutorialInterface;
    vector<shared_ptr<Text>> texts;
    vector<shared_ptr<Arrow>> arrows;
    
    ofVec2f lastTouch;
    float deltaMove;
    float movedLength = 0;
    bool begunToFill = false;
    
public:
    
    TutorialScene();
    TutorialScene(shared_ptr<ofTrueTypeFont> _mainFont);

    void setup() override;
    void update() override;
    void renderToScreen() override;
    
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback) override;
    
};

#endif /* TutorialScene_h */
