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
    
    interface.addButton("HAHA", "HUHU", ofVec2f(100, 100));
    
}

void Menu::renderToFbo(){
    
    ofSetColor(0, 0, 0);
    ofDrawRectangle(0, 0, ofGetWindowWidth(), ofGetWindowHeight());
    interface.draw();
    
}

void Menu::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void Menu::mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDrag(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Menu::mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_position, [&](string text, string action){
        callback(text, action);
    });
    
}
