//
//  Text.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 21.12.16.
//
//

#include "Text.h"

Text::Text(){};

Text::Text(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Text::draw(){
    
    if(font == nullptr) return;
    
    ofPushStyle();
    ofSetLineWidth(1);
    ofNoFill();
    font->drawString(text, getPosition().x - dimensions.x / 2, getPosition().y + dimensions.y / 2);
    ofPopStyle();
    
}

//Set

void Text::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Text::setText(string _text){
    
    text = _text;
    
    dimensions.x = font->stringWidth(text);
    dimensions.y = font->stringHeight(text);
    
}

//Get

ofVec2f Text::getDimensions(){
    
    return dimensions;
    
}

string Text::getText(){
    
    return text;
    
}
