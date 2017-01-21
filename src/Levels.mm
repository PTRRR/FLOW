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
//    interface.addText("LEVELS", ofVec2f(ofGetWidth() / 2, ofGetHeight() * 0.06 / 2));
    
    backButtonImg.load("images/back_button.png");
    shared_ptr<Button> backButton = interface.addButton("BACK", "BACK", ofVec2f(0.0390625 * ofGetWidth()));
    backButton->setDimensions(ofVec2f(0.0390625 * ofGetWidth()));
    backButton->setImage(backButtonImg);
    
    downloadLevelsToIOSDirectory();

}

//Private

void Levels::downloadLevelsToIOSDirectory(){
    
    int levelIndex = 1;
    ofxXmlSettings XMLTemp;
    
    while (XMLTemp.load("scene_" + to_string(levelIndex) + ".xml")) {
        
        XMLTemp.saveFile(ofxiOSGetDocumentsDirectory() + "scene_" + to_string(levelIndex) + ".xml");
        levelIndex ++;
        
    }
    
    cout << levelIndex - 1 << " levels downloaded to ios directory" << endl;
    
}

//Public

void Levels::setup(){
    
    //Reset all.
    
    for(int i = buttons.size() - 1; i >= 0; i--){
    
        interface.removeButton(buttons[i]);
        buttons.erase(buttons.begin() + i);
        levels.erase(levels.begin() + i);
        
    }

    //Set up new buttons.
    
    int levelIndex = 1;
    
    ofxXmlSettings XMLTemp;
    
    while (XMLTemp.load(ofxiOSGetDocumentsDirectory() + "scene_" + to_string(levelIndex) + ".xml")) {
        
        string file = "scene_" + to_string(levelIndex) + ".xml";
        
        levels.push_back(file);
        
        shared_ptr<Button> newButton = interface.addButton(to_string(levelIndex), "scene_" + to_string(levelIndex) + ".xml", ofVec2f(0));
        
        newButton->setMass(10);
        newButton->setDamping(0.4);
        newButton->setMaxVelocity(10000);
        
        if(XMLTemp.getValue("general:UNLOCKED", 0) == 0){
            
            newButton->setActive(true);
            
        }else{
            
            newButton->setActive(true);
            
        }
        
        buttons.push_back(newButton);
        
        levelIndex ++;
        
    }
    
    int numLevels = levelIndex -1;
    
    //Set the buttons to the right position once whe know how much they are.
    
    for(int i = 0; i < numLevels; i++){
        
        ofVec2f buttonPosition = ofVec2f(ofGetWidth() / 2, (ofGetHeight() / 2) + (ofGetHeight() * lineHeightMultiplier * i ) - ((ofGetHeight() * lineHeightMultiplier * (numLevels - 1) ) / 2) );
        buttons[i]->setPosition(buttonPosition);
        
    }
    
}

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
    
}

void Levels::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    ofSetColor(180, getAlpha());
    interface.draw();
    
    for(int i = 0; i < buttons.size(); i++){
        
        if(!buttons[i]->isActive()){
            
            float lineLength = 50;
            ofDrawLine(buttons[i]->getPosition().x - lineLength / 2, buttons[i]->getPosition().y, buttons[i]->getPosition().x + lineLength / 2, buttons[i]->getPosition().y);
            
        }
        
    }
    
}

//Set

void Levels::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

void Levels::setUnlocked(string _xmlFile){
    
    ofxXmlSettings xml;
    
    xml.load(ofxiOSGetDocumentsDirectory() + _xmlFile);
    
    xml.setValue("general:UNLOCKED", 1);
    xml.saveFile(ofxiOSGetDocumentsDirectory() + _xmlFile);
    
}

//Get

vector<string> Levels::getLevels(){
    
    return levels;
    
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
     
//        deltaMove = ofVec2f(0, _touch.y - lastPos.y);
        
//        movement += deltaMove.y;
        
        lastPos = _touch;
        
    }
    
}

void Levels::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        if(abs(movement) < 5 && _touch.id == 0) callback(text, action);
    });
    
}
