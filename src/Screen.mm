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
    
    alpha = 1.0f;
    alphaTarget = 1.0f;
    zIndex = 0;
    
    active = false;

    fbo.allocate(w, h, GL_RGBA);

}

void Screen::render(){
    
    fbo.begin();
    renderToFbo();
    fbo.end();
    
    texture = fbo.getTexture();
    
}

void Screen::draw(){
    
    texture.draw(0.0f, 0.0f);
    
}

//Set

void Screen::setAlpha(float _alpha){
    
    //Clamp the value between 0 and 1
    
    if(_alpha <= 0) this->alpha = 0;
    else if (_alpha >= 1) this->alpha = 1;
    else this->alpha = _alpha;
    
}

void Screen::setAlphaTarget(float _alphaTarget){
    
    //Clamp the value between 0 and 1
    
    if(_alphaTarget <= 0) this->alphaTarget = 0;
    else if (_alphaTarget >= 1) this->alphaTarget = 1;
    else this->alphaTarget = _alphaTarget;
    
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

float Screen::getAlpha(){
    
    return alpha;
    
}

bool Screen::isVisible(){
    
    if(alpha > 0) return true;
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

