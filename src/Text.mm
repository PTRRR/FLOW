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
    color = ofFloatColor(255, 255, 255, 255);
    
}

void Text::draw(){
    
    if(font == nullptr) return;
    
    ofPushStyle();
    ofSetLineWidth(1);
    ofNoFill();
    ofSetColor(color);
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

void Text::setColor(ofFloatColor _color){
    
    color = _color;
    
}

void Text::setAlpha(float _alpha){
    
    color.a = _alpha;
    
}

//Get

ofVec2f Text::getDimensions(){
    
    return dimensions;
    
}

string Text::getText(){
    
    return text;
    
}

ofFloatColor Text::getColor(){
    
    return color;
    
}

float Text::getAlpha(){
    
    return color.a;
    
}
