//
//  Levels.mm
//  FLOW
//
//  Created by Pietro Alberti on 05.01.17.
//
//

#include "Levels.h"

Levels::Levels(){}

Levels::Levels(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
    int levelIndex = 1;
    
    while (XMLExists("scene_" + to_string(levelIndex) + ".xml")) {
     
        interface.addButton("LEVEL " + to_string(levelIndex), "scene_" + to_string(levelIndex) + ".xml", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * 0.05 * (levelIndex - 1)));
        
        levelIndex ++;
        
    }
    
}

//Private

bool Levels::XMLExists(string _xmlName){
    
    ofxXmlSettings XML;
    
    if( XML.loadFile(_xmlName) ){
        
        return true;
        
    }else if( XML.loadFile(ofxiOSGetDocumentsDirectory() + _xmlName) ){
        
        return true;
        
    }else{
        
        return false;
        
    }
    
}

//Public

void Levels::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    ofSetColor(255, 255, 255, getAlpha());
    interface.draw();
    
}

void Levels::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

//Inputs

void Levels::onMouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Levels::onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Levels::onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDrag(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Levels::onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_position, [&](string text, string action){
        callback(text, action);
    });
    
}