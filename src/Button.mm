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
    size = ofVec2f(0);

};

void Button::draw(){
    
    if(img.isAllocated()){
        
        img.draw(getPosition().x - dimensions.x / 2, getPosition().y - dimensions.y / 2, dimensions.x, dimensions.y);
        
    }else{
     
        if(font == nullptr) return;
        
//        float left = getPosition().x - dimensions.x / 2 - offset;
//        float top = getPosition().y - dimensions.y / 2 - offset;
        
        font->drawString(text, getPosition().x - dimensions.x / 2, getPosition().y + dimensions.y / 2);
        
    }
    
}

//Set

void Button::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Button::setText(string _text){
    
    text = _text;
    
    dimensions.x = font->stringWidth(text);
    dimensions.y = font->stringHeight(text);
    
}

void Button::setAction(string _action){
    
    action = _action;
    
}

void Button::setImage(ofImage _image){
    
    img = _image;
    
}

void Button::setDimensions(ofVec2f _dimensions){
    
    dimensions = _dimensions;
    
}

//Get

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
    
    float left = getPosition().x - dimensions.x / 2 - offset;
    float top = getPosition().y - dimensions.y / 2 - offset;
    float right = left + dimensions.x + offset * 2 + 5;
    float down = top + dimensions.y + offset * 2 + 5;
    
    if(_position.x >= left && _position.x <= right && _position.y >= top && _position.y <= down){
        return true;
    }else{
        return false;
    }
    
}

