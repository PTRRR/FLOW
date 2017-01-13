//
//  End.mm
//  FLOW
//
//  Created by Pietro Alberti on 09.01.17.
//
//

#include "End.h"

End::End(){}

End::End(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(font);
    
    interface.addText("THE END", ofVec2f(ofGetWidth() / 2, ofGetHeight() * 0.06 / 2));
    interface.addButton("RESTART", "RESTART", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2));
    interface.addButton("MENU", "MENU", ofVec2f(ofGetWidth() / 2, ofGetHeight() - ofGetHeight() * 0.06 / 2));
    
}

void End::renderToScreen(){
    
    ofSetColor(255, 255, 255, getAlpha());
    interface.draw();
    
}

void End::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void End::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void End::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}

void End::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        callback(text, action);
    });
    
}