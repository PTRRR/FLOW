//
//  SplashScreen.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "SplashScreen.h"

SplashScreen::SplashScreen(){}

SplashScreen::SplashScreen(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(font);
    interface.addText("F L O W", ofVec2f(ofGetWindowWidth() / 2, ofGetWindowHeight() / 2));
    
}

void SplashScreen::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWindowWidth(), ofGetWindowHeight());
    interface.draw();
    
}

void SplashScreen::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void SplashScreen::onMouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void SplashScreen::onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void SplashScreen::onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDrag(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void SplashScreen::onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_position, [&](string text, string action){
        callback(text, action);
    });
    
}


