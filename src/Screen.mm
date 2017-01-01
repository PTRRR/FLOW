//
//  Screen.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "Screen.h"

Screen::Screen(){
    
    w = ofGetWindowWidth();
    h = ofGetWindowHeight();
    
    //By default
    
    mainAlpha = 255;
    alphaTarget = 255;
    zIndex = 0;
    
    active = false;
    
    fbo.allocate(ofGetWidth(), ofGetHeight(), GL_RGBA);

}

void Screen::draw(){
    
    fbo.begin();
    mainAlpha += (alphaTarget - mainAlpha) * 0.1;
    
    if(mainAlpha > 1){
        ofPushStyle();
        ofPushMatrix();
        
        renderToScreen();
        
        ofPopMatrix();
        ofPopStyle();
    }
    
    fbo.end();
    
    ofPushStyle();
    
    ofSetColor(255, 255, 255, mainAlpha);
    fbo.draw(0, 0, ofGetWidth() + 2, ofGetHeight());
    
    ofPopStyle();
    

}

//Inputs

void Screen::mouseDown(ofVec2f _position, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseDown(_position, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::mouseMove(ofVec2f _position, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseMove(_position, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::mouseDrag(ofVec2f _position, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseDrag(_position, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::mouseUp(ofVec2f _position, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseUp(_position, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

//Set

void Screen::setAlpha(float _alpha){
    
    //Clamp the value between 0 and 1
    
    mainAlpha = ofClamp(_alpha, 0.0f, 255.0f);
    
}

void Screen::setAlphaTarget(float _alphaTarget){
    
    //Clamp the value between 0 and 1
    
    alphaTarget = ofClamp(_alphaTarget, 0.0f, 255.0f);
    
}

void Screen::setIndex(int _index){
    
    this->zIndex = _index;
    
}

void Screen::setActive(bool _active){
    
    this->active = _active;
    
}

void Screen::setName(string _name){
    
    this->name = _name;
    
}

//Get

float Screen::alpha(float _alpha){

    return mainAlpha - (255.0 - _alpha);
    
}

float Screen::getAlpha(){
    
    return mainAlpha;
    
}

bool Screen::isVisible(){
    
    if(mainAlpha > 0) return true;
    return false;
    
}

int Screen::getIndex(){
    
    return zIndex;
    
}

bool Screen::isActive(){
    
    return active;
    
}

string Screen::getName(){
    
    return name;
    
}

