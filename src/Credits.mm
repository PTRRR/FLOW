//
//  Credits.mm
//  FLOW
//
//  Created by Pietro Alberti on 22.01.17.
//
//

#include "Credits.h"

Credits::Credits(){};

Credits::Credits(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
    creditsString = "By Pietro Alberti\nPart of the advanced interaction course\nLed by Gaël Hugo\nAssisted by Laura Perrenoud and Tibor Udvari\nECAL/Bachelor Media & Interaction Design\nUniversity of Art & Design, Lausanne\nwww.ecal.ch";
    
    shared_ptr<ofTrueTypeFont> myryadPro = shared_ptr<ofTrueTypeFont>(new ofTrueTypeFont());
    myryadPro->load("MyriadPro-Regular.otf", 30);
    
    renensLight = shared_ptr<ofTrueTypeFont>(new ofTrueTypeFont());
    renensLight->load("Renens-Light.ttf", 0.01392773438 * ofGetHeight());
    
    credits.setFont(renensLight);
    
    
    renensMedium = shared_ptr<ofTrueTypeFont>(new ofTrueTypeFont());
    renensMedium->load("Renens-Medium.ttf", ofGetHeight() * 0.02432519531);
    
    title.setFont(renensMedium);
    title.addText("FLOW", ofVec2f(100, 200));
    
    ecalLogo.load("images/ecal_logo.png");
    
}

void Credits::renderToScreen(){
    
    ofSetColor(0, 0, 0, getAlpha());
    ofDrawRectangle(0, 0, ofGetWidth() + 1, ofGetHeight());
    
    ofSetColor(180, getAlpha());
    renensMedium->drawString("Flow Particles", 0.06160546875 * ofGetWidth(), 0.2830546875 * ofGetHeight());
    renensLight->drawString(creditsString, 0.06160546875 * ofGetWidth(), 0.34675 * ofGetHeight());
    
    ecalLogo.draw(0.06160546875 * ofGetWidth(), 0.9126425781 * ofGetHeight(), 0.1634661458 * ofGetWidth(), 0.0379765625 * ofGetHeight());
    
}

void Credits::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

//Inputs

void Credits::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    callback("FIRST-MENU", "FIRST-MENU");
    
}
