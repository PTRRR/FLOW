#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	

    mainFont = shared_ptr<ofTrueTypeFont>(new ofTrueTypeFont());
    mainFont->load("GT-Pressura-Mono-Light.ttf", 0.01953125 * ofGetWidth());
    mainFont->setLetterSpacing(1.5);
    
    gameManager = GameManager(mainFont);
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    if(!running) return;

    gameManager.update();
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofClear(0, 0, 0);
    
    
    if(ofGetElapsedTimeMillis() > 1500 && ofGetElapsedTimeMillis() < 2000){
        running = true;
    }
    
    if(running){
      
        ofEnableAlphaBlending();
        
        gameManager.draw();
        
        ofDisableAlphaBlending();
        
    };
    
    ofSetColor(255, 0, 0);
//    ofDrawBitmapString(ofGetFrameRate(), 20, 20);
    
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    
    gameManager.mouseDown(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

    gameManager.mouseMove(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

    gameManager.mouseUp(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

    gameManager.doubleClick(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

    cout << "MEMORY WARNING" << endl;
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
