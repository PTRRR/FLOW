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
    
    ofSetColor(255, 255, 255);
    ofSetLineWidth(1);
    ofNoFill();
    font->drawString(text, position.x - dimensions.x / 2, position.y + dimensions.y / 2);
    
}

//Set

void Text::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Text::setPosition(ofVec2f _position){
    
    position = _position;
    
}

void Text::setText(string _text){
    
    text = _text;
    
    dimensions.x = font->stringWidth(text);
    dimensions.y = font->stringHeight(text);
    
}

//Get

ofVec2f Text::getPosition(){
    
    return position;
    
}

ofVec2f Text::getDimensions(){
    
    return dimensions;
    
}

string Text::getText(){
    
    return text;
    
}
