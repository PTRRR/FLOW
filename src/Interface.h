//
//  Interface.h
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#ifndef Interface_h
#define Interface_h

#include <stdio.h>
#include "ofxiOS.h"
#include "Button.h"
#include "Text.h"

class Interface {

private:
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Elements
    
    vector<shared_ptr<Button>> buttons;
    vector<shared_ptr<Text>> texts;
    
public:
    
    Interface();
    Interface(shared_ptr<ofTrueTypeFont> _font);
    
    void draw();
    void addButton(string _text, string _action, ofVec2f _position);
    void addText(string _text, ofVec2f _position);
    
    //Inputs
    
    void mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback);
    void mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback);
    void mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback);
    void mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback);
    
    //Set
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* Interface_h */
