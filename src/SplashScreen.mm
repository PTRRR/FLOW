//
//  SplashScreen.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "SplashScreen.h"

SplashScreen::SplashScreen(){}

SplashScreen::SplashScreen(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void SplashScreen::update(){
    
    if(letterElements.size() == 0){
        for(int i = 0; i < title.length(); i++){
            
            shared_ptr<BaseElement> newLetterElement = shared_ptr<BaseElement>(new BaseElement());
            newLetterElement->setPosition(ofVec2f(ofRandom(ofGetWidth()), ofRandom(ofGetHeight())));
            newLetterElement->setDamping(0.85);
            newLetterElement->setMass(30);
            newLetterElement->setMaxVelocity(100);
            letterElements.push_back(newLetterElement);
            
        }
    }
    
    for(int i = 0; i < letterElements.size(); i++){
        
        string letter(1, title[i]);
        float width = ofGetWidth() * 0.2;
        ofVec2f targetPosition;
        targetPosition.x = (ofGetWidth() / 2) - (width / 2) + i * (width / (letterElements.size() - 1)) - font->stringWidth(letter) / 2;
        targetPosition.y = (ofGetHeight() / 2) + font->stringHeight(letter) / 2;
        ofVec2f force = targetPosition - letterElements[i]->getPosition();
        letterElements[i]->applyForce(force);
        
        letterElements[i]->update();
        
    }
    
}

void SplashScreen::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    ofSetColor(255, 255, 255, getAlpha());
    
    for(int i = 0; i < letterElements.size(); i++){
        
        string letter(1, title[i]);
        font->drawString(letter, letterElements[i]->getPosition().x, letterElements[i]->getPosition().y);
        
    }
    
}

void SplashScreen::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}


