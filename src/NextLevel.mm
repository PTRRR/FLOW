//
//  NextLevel.mm
//  FLOW
//
//  Created by Pietro Alberti on 09.01.17.
//
//

#include "NextLevel.h"

NextLevel::NextLevel(){}

NextLevel::NextLevel(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(font);
    
//    interface.addText("LEVEL FINISHED", ofVec2f(ofGetWidth() / 2, ofGetHeight() * 0.06 / 2));
    interface.addButton("RESTART", "RESTART", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 - ofGetHeight() * 0.06 / 2));
    interface.addButton("NEXT LEVEL", "NEXT-LEVEL", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * 0.06 / 2));
    interface.addButton("MENU", "MENU", ofVec2f(ofGetWidth() / 2, ofGetHeight() - ofGetHeight() * 0.06 / 2));
    
}

void NextLevel::renderToScreen(){
    
    ofSetColor(180, getAlpha());
//    ofSetColor(255, 255, 255, getAlpha());
    interface.draw();
    
}

void NextLevel::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void NextLevel::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void NextLevel::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void NextLevel::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}
