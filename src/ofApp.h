#pragma once

#include "ofxiOS.h"
#include "GameManager.h"

class ofApp : public ofxiOSApp {
	
public:
    void setup();
    void update();
    void draw();
    void exit();

    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    float maxFrameRate = 0.0;
    bool running = false;

    //Main font
    
    shared_ptr<ofTrueTypeFont> mainFont;
    
    //Game manager
    
    GameManager gameManager;

};


