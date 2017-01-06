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
#include "BaseElement.h"

class Button : public BaseElement{

private:
    
    //Settings
    
    shared_ptr<ofTrueTypeFont> font;
    ofVec2f dimensions;
    float offset = 25;
    
    //Content
    
    string text, action;
    
public:
    
    Button();
    Button(shared_ptr<ofTrueTypeFont> _font);
    
    void draw();
    
    //Set
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    void setText(string _text);
    void setAction(string _action);
    
    //Get
    
    ofVec2f getDimensions();
    
    string getText();
    string getAction();
    
    bool isOver(ofVec2f _position);
    
};

#endif /* Button_h */
