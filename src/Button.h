//
//  Button.h
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#ifndef Button_h
#define Button_h

#include <stdio.h>
#include "ofxiOS.h"

class Button {

private:
    
    //Settings
    
    shared_ptr<ofTrueTypeFont> font;
    ofVec2f position, dimensions;
    float offset = 5;
    
    //Content
    
    string text, action;
    
public:
    
    Button();
    Button(shared_ptr<ofTrueTypeFont> _font);
    
    void draw();
    
    //Set
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    void setPosition(ofVec2f _position);
    void setText(string _text);
    void setAction(string _action);
    
    //Get
    
    ofVec2f getPosition();
    ofVec2f getDimensions();
    
    string getText();
    string getAction();
    
    bool isOver(ofVec2f _position);
    
};

#endif /* Button_h */
