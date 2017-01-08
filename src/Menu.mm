//
//  Menu.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "Menu.h"

Menu::Menu(){};

Menu::Menu(shared_ptr<ofTrueTypeFont> _font){

    font = _font;
    interface.setFont(font);
    
    interface.addButton("[ PLAY ]", "PLAY", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 - ofGetHeight() * 0.06 / 2));
    interface.addButton("[ EXIT ]", "EXIT", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * 0.06 / 2));
    
}

void Menu::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    ofSetColor(255, 255, 255, getAlpha());
    interface.draw();
    
}

void Menu::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void Menu::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}
