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
    
    mainAlpha = 255;
    alphaTarget = 255;
    zIndex = 0;
    
    active = false;
    
    fbo.allocate(ofGetWidth(), ofGetHeight(), GL_RGBA);

}

void Screen::draw(){
    
//    fbo.begin();
    mainAlpha += (alphaTarget - mainAlpha) * 0.2;
    
    if(mainAlpha > 1){
        ofPushStyle();
        ofPushMatrix();
        
        renderToScreen();
        
        ofPopMatrix();
        ofPopStyle();
    }
    
//    fbo.end();
    
    ofPushStyle();
    
//    ofSetColor(255, 255, 255, mainAlpha);
//    fbo.draw(0, 0, ofGetWidth() + 2, ofGetHeight());
    
    ofPopStyle();
    

}

//Inputs

void Screen::mouseDown(ofTouchEventArgs & _touch, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseDown(_touch, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::mouseMove(ofTouchEventArgs & _touch, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseMove(_touch, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::mouseDrag(ofTouchEventArgs & _touch, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseDrag(_touch, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::mouseUp(ofTouchEventArgs & _touch, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onMouseUp(_touch, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

void Screen::doubleClick(ofTouchEventArgs & _touch, function<void (string _text, string _action)> _callback){
    
    if(isActive()){
        onDoubleClick(_touch, [&](string text, string action){
            
            _callback(text, action);
            
        });
    }
    
}

//Set

void Screen::setAlpha(float _alpha){
    
    //Clamp the value between 0 and 1
    
    mainAlpha = ofClamp(_alpha, 0.0f, 255.0f);
    
}

void Screen::setAlphaTarget(float _alphaTarget){
    
    //Clamp the value between 0 and 1
    
    alphaTarget = ofClamp(_alphaTarget, 0.0f, 255.0f);
    
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

float Screen::alpha(float _alpha){

    return mainAlpha - (255.0 - _alpha);
    
}

float Screen::getAlpha(){
    
    return mainAlpha;
    
}

bool Screen::isVisible(){
    
    if(mainAlpha > 0) return true;
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

//XML

bool Screen::XMLExists(string _xmlName){
    
    ofxXmlSettings XML;
    
    if( XML.loadFile(_xmlName) ){
        
        return true;
        
    }else if( XML.loadFile(ofxiOSGetDocumentsDirectory() + _xmlName) ){
        
        return true;
        
    }else{
        
        return false;
        
    }
    
}

void Screen::saveXML(string _name, ofxXmlSettings _XML){
    
    string message = "";
    
    if( _XML.saveFile(_name) ){
        
        message = _name + " saved in the data folder!";
        
    }else if( _XML.saveFile(ofxiOSGetDocumentsDirectory() + _name) ){
        
        message = _name + " saved in the documents folder!";
        
    }else{
        
        message = "Unable to save " + _name + " check data/ folder";
        
    }
    
    cout << message << endl;
    
}

void Screen::loadXML(string _xmlFile, function<void(ofxXmlSettings _XML)> _callback){
    
    ofxXmlSettings XML;
    
    string message = "";
    
    if( XML.loadFile(_xmlFile) ){
        
        message = _xmlFile + " loaded from data folder!";
        cout << message << endl;
        
        _callback(XML);
        
    }else if( XML.loadFile(ofxiOSGetDocumentsDirectory() + _xmlFile) ){
        
        message = _xmlFile + " loaded from documents folder!";
        cout << message << endl;
        
        _callback(XML);
        
    }else{
        
        message = "unable to load " + _xmlFile + " check data/ folder";
        cout << message << endl;
        
    }
    
}

void Screen::loadXML(string _xmlFile, function<void(ofxXmlSettings _XML)> _callback, bool _directory){
    
    ofxXmlSettings XML;
    
    string message = "";
    
    if( XML.loadFile(_xmlFile) && !_directory ){
        
        message = _xmlFile + " loaded from data folder!";
        cout << message << endl;
        
        _callback(XML);
        
    }else if( XML.loadFile(ofxiOSGetDocumentsDirectory() + _xmlFile) && _directory ){
        
        message = _xmlFile + " loaded from documents folder!";
        cout << message << endl;
        
        _callback(XML);
        
    }else{
        
        message = "unable to load " + _xmlFile + " check data/ folder";
        cout << message << endl;
        
    }
    
}

void Screen::logXML(string _fileName){
    
    loadXML(_fileName, [&](ofxXmlSettings _xml){
        
        string content;
        
        _xml.copyXmlToString(content);
        
        cout << content << endl;
        
    });
    
}

void Screen::logXML(ofxXmlSettings _XML){
        
    string content;
    
    _XML.copyXmlToString(content);
    
    cout << content << endl;
    
}

