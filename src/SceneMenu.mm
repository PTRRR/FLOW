//
//  SceneMenu.mm
//  FLOW
//
//  Created by Pietro Alberti on 08.01.17.
//
//

#include "SceneMenu.h"

SceneMenu::SceneMenu(){};

SceneMenu::SceneMenu(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(font);
    
//    interface.addText("MENU", ofVec2f(ofGetWidth() / 2, ofGetHeight() * 0.06 / 2));
    interface.addButton("RESUME", "RESUME", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 - ofGetHeight() * 0.06 / 2));
    interface.addButton("LEVELS", "PLAY", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * 0.06 / 2));
    interface.addButton("EXIT", "EXIT", ofVec2f(ofGetWidth() / 2, ofGetHeight() - ofGetHeight() * 0.06 / 2));
    
    mainSound.load("sounds/main.mp3");
    mainSound.setLoop(true);
    mainSound.setVolume(getVolume());
    mainSound.play();
    
}

void SceneMenu::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    ofSetColor(180, getAlpha());
    interface.draw();
    
}

void SceneMenu::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void SceneMenu::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void SceneMenu::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void SceneMenu::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}
