//
//  Text.h
//  ofMagnet
//
//  Created by Pietro Alberti on 21.12.16.
//
//

#ifndef Text_h
#define Text_h

#include <stdio.h>
#include "ofxiOS.h"

class Text {

private:
    
    shared_ptr<ofTrueTypeFont> font;
    
    ofVec2f position;
    ofVec2f dimensions;
    
    string text;
    
public:

    Text();
    Text(shared_ptr<ofTrueTypeFont> _font);
    
    void draw();
    
    //Set
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    void setPosition(ofVec2f _position);
    void setText(string _text);
    
    //Get
    
    ofVec2f getPosition();
    ofVec2f getDimensions();
    
    string getText();
    string getAction();
    
};

#endif /* Text_h */
