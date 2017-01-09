//
//  Levels.h
//  FLOW
//
//  Created by Pietro Alberti on 05.01.17.
//
//

#ifndef Levels_h
#define Levels_h

#include <stdio.h>
#include "Screen.h"
#include "Interface.h"
#include "ofxXmlSettings.h"
#include "Button.h"

class Levels : public Screen{

private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Main
    
    vector<string> levels;
    
    //Interface
    
    ofImage backButtonImg;
    vector<shared_ptr<Button>> buttons;
    vector<bool> levelsStatus;
    
    
    float lineHeightMultiplier = 0.06;
    ofVec2f lastPos = ofVec2f(0);
    ofVec2f deltaMove = ofVec2f(0);
    bool hasMoved = false;
    float movement = 0;
    Interface interface;
    
    //Rendering
    
    void renderToScreen() override;
    
    //Inputs
    
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
    //Utils
    
    void downloadLevelsToIOSDirectory();
    
public:
    
    Levels();
    Levels(shared_ptr<ofTrueTypeFont> _font);
    
    void update() override;
    void setup();
    
    //Set
    
    void setUnlocked(string _xmlFile);
    
    //Get
    
    vector<string> getLevels();
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* Levels_h */
