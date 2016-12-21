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
    
    float left = position.x - dimensions.x / 2;
    float top = position.y - dimensions.y / 2;

    ofDrawCircle(position.x, position.y, 2);
    
    ofDrawRectangle(left, top, dimensions.x, dimensions.y);
    font->drawString(text, position.x - dimensions.x / 2, position.y + dimensions.y / 2);
    
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
    
    dimensions.x = font->stringWidth(text);
    dimensions.y = font->stringHeight(text);
    
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
    
    float left = position.x - dimensions.x / 2;
    float top = position.y - dimensions.y / 2;
    float right = left + dimensions.x;
    float down = top + dimensions.y;
    
    if(_position.x >= left && _position.x <= right && _position.y >= top && _position.y <= down){
        cout << "asdafasd" << endl;
        return true;
    }else{
        return false;
    }
    
}

