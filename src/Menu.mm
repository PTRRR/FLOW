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
    
    interface.addButton("P L A Y", "PLAY", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 - ofGetHeight() * 0.06 / 2));
    interface.addButton("E X I T", "EXIT", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * 0.06 / 2));
    
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

void Menu::onMouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDrag(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_position, [&](string text, string action){
        callback(text, action);
    });
    
}
