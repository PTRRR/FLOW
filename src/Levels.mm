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
    
    interface.addText("LEVELS", ofVec2f(ofGetWidth() / 2, ofGetHeight() * 0.06 / 2));
    
    backButtonImg.load("images/backButton.png");
    shared_ptr<Button> backButton = interface.addButton("BACK", "BACK", ofVec2f(0.0390625 * ofGetWidth()));
    backButton->setDimensions(ofVec2f(0.0390625 * ofGetWidth()));
    backButton->setImage(backButtonImg);
    
    while (XMLExists("scene_" + to_string(levelIndex) + ".xml")) {
     
        shared_ptr<Button> newButton = interface.addButton("[ " + to_string(levelIndex) + " ]", "scene_" + to_string(levelIndex) + ".xml", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + ofGetHeight() * lineHeightMultiplier * (levelIndex - 1)));

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

void Levels::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
    });
    
    if(_touch.id == 0){
     
        lastPos = _touch;
        movement = 0;
        
    }
    
}

void Levels::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_touch, [&](string text, string action){
        callback(text, action);
    });
    
    if(_touch.id == 0){
     
        deltaMove = ofVec2f(0, _touch.y - lastPos.y);
        
        movement += deltaMove.y;
        
        lastPos = _touch;
        
    }
    
}

void Levels::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        if(abs(movement) < 5 && _touch.id == 0) callback(text, action);
    });
    
}