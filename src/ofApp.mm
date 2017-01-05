#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	

    mainFont = shared_ptr<ofTrueTypeFont>(new ofTrueTypeFont());
    mainFont->load("GT-Cinetype-Trial-Regular.otf", 40);
    
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
    ofDrawBitmapString("FPS: " + to_string((int) floor(ofGetFrameRate() * 10) / 10), 20, 20);
    
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

    gameManager.mouseDown(ofVec2f(touch.x, touch.y));
    
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

    gameManager.mouseMove(ofVec2f(touch.x, touch.y));
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

    gameManager.mouseUp(ofVec2f(touch.x, touch.y));
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

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
