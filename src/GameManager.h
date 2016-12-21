//
//  GameManager.h
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#ifndef GameManager_h
#define GameManager_h

#include <stdio.h>
#include "ofxiOS.h"
#include "ScreenPipeline.h"
#include "Menu.h"
#include "SplashScreen.h"

class GameManager {

private:
    
    shared_ptr<ofTrueTypeFont> mainFont;
    
    //Screens
    
    ScreenPipeline screenPipeline;
    
    shared_ptr<SplashScreen> splashScreen;
    shared_ptr<Menu> menu;
    
public:
    
    GameManager();
    GameManager(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void draw();
    
    //Input
    
    void mouseDown(ofVec2f _position);
    
};

#endif /* GameManager_h */
