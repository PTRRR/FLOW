//
//  Button.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#include "Button.h"

Button::Button(){};

Button::Button(shared_ptr<ofTrueTypeFont> _font){

    font = _font;

};

void Button::draw(){
    
    if(font == nullptr) return;
    
    ofSetColor(255, 255, 255);
    ofSetLineWidth(1);
    ofNoFill();
//    ofDrawRectangle(position.x - offset, position.y - (dimensions.y - (dimensions.y - font->stringHeight(text))) - offset, dimensions.x + offset * 2, dimensions.y + offset * 2);
    font->drawString(text, position.x - dimensions.x / 2, position.y - dimensions.y / 2);
    
}

//Set

void Button::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Button::setPosition(ofVec2f _position){
    
    position = _position;
    
}

void Button::setText(string _text){
    
    text = _text;
    
    dimensions.x = font->stringWidth(text) + 4;
    dimensions.y = font->getLineHeight();
    
}

void Button::setAction(string _action){
    
    action = _action;
    
}

//Get

ofVec2f Button::getPosition(){
    
    return position;
    
}

ofVec2f Button::getDimensions(){
    
    return dimensions;
    
}

string Button::getText(){
    
    return text;
    
}

string Button::getAction(){
    
    return action;
    
}

bool Button::isOver(ofVec2f _position){
    
    float left = position.x - offset;
    float right = position.x + dimensions.x + offset;
    float up = position.y - (dimensions.y - (dimensions.y - font->stringHeight(text))) - offset;
    float down = up + dimensions.y + offset * 2;
    
    if(_position.x >= left && _position.x <= right && _position.y >= up && _position.y <= down){
        return true;
    }else{
        return false;
    }
    
}

