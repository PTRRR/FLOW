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

class Levels : public Screen{

private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Interface
    
    Interface interface;
    bool XMLExists(string _xmlName);
    
    //Rendering
    
    void renderToScreen() override;
    
    //Inputs
    
    void onMouseDown(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    
public:
    
    Levels();
    Levels(shared_ptr<ofTrueTypeFont> _font);
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* Levels_h */
