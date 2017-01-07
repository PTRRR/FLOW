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
    interface.setMass(50);
    interface.setMaxVelocity(100);
    interface.setDamping(0.9);
    interface.setFont(_font);
    
    int levelIndex = 1;
    
    while (XMLExists("scene_" + to_string(levelIndex) + ".xml")) {
     
        shared_ptr<Button> newButton =  interface.addButton("LEVEL " + to_string(levelIndex), "scene_" + to_string(levelIndex) + ".xml", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * lineHeightMultiplier * (levelIndex - 1)));

        newButton->setMass(10);
        newButton->setDamping(0.4);
        newButton->setMaxVelocity(10000);
        
        buttons.push_back(newButton);
        
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

void Levels::update(){
    
    if(buttons.size() > 0){
        
        if(deltaMove.y < 0){
            
            buttons[0]->setPosition(buttons[0]->getPosition() + deltaMove);
            
        }else if (deltaMove.y > 0){
            
            buttons[buttons.size() - 1]->setPosition(buttons[buttons.size() - 1]->getPosition() + deltaMove);
            
        }
     
        for(int i = 0; i < buttons.size(); i++){
            
            if(deltaMove.y < 0){
                
                if(i > 0){
                    
                    ofVec2f offset = ofVec2f(0, ofGetHeight() * lineHeightMultiplier);
                    ofVec2f newPosition = buttons[i]->getPosition() + (buttons[i - 1]->getPosition() + offset - buttons[i]->getPosition()) * 0.7;
                    
                    buttons[i]->setPosition(newPosition);
                    
                }
                
            }else if(deltaMove.y > 0){
                
                if(i < buttons.size() - 1){
                    
                    ofVec2f offset = ofVec2f(0, ofGetHeight() * lineHeightMultiplier);
                    ofVec2f newPosition = buttons[i]->getPosition() + (buttons[i + 1]->getPosition() - offset - buttons[i]->getPosition()) * 0.7;
                    
                    buttons[i]->setPosition(newPosition);
                    
                }
                
            }
            
        }
        
        deltaMove *= 0.95;
        
    }
    
    //Limit movement
    
    if(buttons[buttons.size() - 1]->getPosition().y > ofGetHeight() / 2 + ofGetHeight() * lineHeightMultiplier * (buttons.size() - 1)){
        
        ofVec2f targetPosition = ofVec2f(buttons[buttons.size() - 1]->getPosition().x, ofGetHeight() / 2 + ofGetHeight() * lineHeightMultiplier * (buttons.size() - 1));
        ofVec2f newPosition = buttons[buttons.size() - 1]->getPosition() + (targetPosition - buttons[buttons.size() - 1]->getPosition()) * 0.3;
        buttons[buttons.size() - 1]->setPosition(newPosition);
        
    }else if(buttons[0]->getPosition().y < ofGetHeight() / 2 - ofGetHeight() * lineHeightMultiplier * (buttons.size() - 1)){
        
        ofVec2f targetPosition = ofVec2f(buttons[0]->getPosition().x, ofGetHeight() / 2 - ofGetHeight() * lineHeightMultiplier * (buttons.size() - 1));
        ofVec2f newPosition = buttons[0]->getPosition() + (targetPosition - buttons[0]->getPosition()) * 0.3;
        buttons[0]->setPosition(newPosition);
        
    }
    
}

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
    
    lastPos = _position;
    movement = 0;
    
}

void Levels::onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    deltaMove = ofVec2f(0, _position.y - lastPos.y);
    
    movement += deltaMove.y;
    
    cout << movement << endl;
    
    interface.mouseMove(_position, [&](string text, string action){
        callback(text, action);
    });
    
    lastPos = _position;
    
}

void Levels::onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    interface.mouseDrag(_position, [&](string text, string action){
        callback(text, action);
    });
    
}

void Levels::onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    cout << movement << endl;
    
    interface.mouseUp(_position, [&](string text, string action){
        if(abs(movement) < 5) callback(text, action);
    });
    
}