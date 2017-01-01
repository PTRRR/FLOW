//
//  ScreenPipeline.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef ScreenPipeline_h
#define ScreenPipeline_h

#include <stdio.h>
#include "Screen.h"

class ScreenPipeline {
    
private:
    
    vector<shared_ptr<Screen>> pipeline;
    shared_ptr<Screen> activeScreen;
    shared_ptr<Screen> lastActiveScreen;
    
public:
    
    ScreenPipeline();
    ScreenPipeline(shared_ptr<Screen> _firstScreen, shared_ptr<Screen> _lastScreen);
    ~ScreenPipeline();
    
    void draw();
    
    void addScreen(shared_ptr<Screen> _screen);
    
    void setScreenActive(shared_ptr<Screen> _screen);
    
    //Get
    shared_ptr<Screen> getActiveScreen();
    shared_ptr<Screen> getLastActiveScreen();
    
};

#endif /* ScreenPipeline_h */
