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
#include "BaseElement.h"

class Interface : public BaseElement{

private:
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Elements
    
    vector<shared_ptr<Button>> buttons;
    vector<shared_ptr<Text>> texts;
    vector<shared_ptr<BaseElement>> elements;
    
public:
    
    Interface();
    Interface(shared_ptr<ofTrueTypeFont> _font);
    
    void draw();
    shared_ptr<Button> addButton(string _text, string _action, ofVec2f _position);
    shared_ptr<Text> addText(string _text, ofVec2f _position);
    
    //Inputs
    
    void mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback);
    void mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback);
    void mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback);
    void mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback);
    
    //Get
    
    shared_ptr<Button> getButton(string _text);
    vector<shared_ptr<Button>> getButtons();
    
    //Set
    
    void setPosition(ofVec2f _position);
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    void removeButton(shared_ptr<Button> _button);
    
};

#endif /* Interface_h */
