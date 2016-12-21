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
    interface.addText("M A G N E T", ofVec2f(ofGetWindowWidth() / 2, ofGetWindowHeight() / 2));
    
    
}

void SplashScreen::renderToFbo(){
    
    ofSetColor(0, 0, 0);
    ofDrawRectangle(0, 0, ofGetWindowWidth(), ofGetWindowHeight());
    interface.draw();
    
}

void SplashScreen::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void SplashScreen::mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void SplashScreen::mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void SplashScreen::mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDrag(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void SplashScreen::mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_position, [&](string text, string action){
        callback(text, action);
    });
    
}


