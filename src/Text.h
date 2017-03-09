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
#include "BaseElement.h"

class Text : public BaseElement{

private:
    
    shared_ptr<ofTrueTypeFont> font;
    
    ofVec2f dimensions;
    ofFloatColor color;
    
    string text;
    
public:

    Text();
    Text(shared_ptr<ofTrueTypeFont> _font);
    
    void draw();
    
    //Set
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    void setText(string _text);
    void setColor(ofFloatColor _color);
    void setAlpha(float _alpha);
    
    //Get
    
    ofVec2f getDimensions();
    
    string getText();
    string getAction();
    ofFloatColor getColor();
    float getAlpha();
    
};

#endif /* Text_h */
