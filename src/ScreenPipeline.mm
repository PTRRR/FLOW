//
//  ScreenPipeline.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "ScreenPipeline.h"

ScreenPipeline::ScreenPipeline(){
    
    this->activeScreen = nullptr;
    this->lastActiveScreen = nullptr;
    
};

ScreenPipeline::ScreenPipeline(shared_ptr<Screen> _firstScreen, shared_ptr<Screen> _lastScreen){
    
    this->activeScreen = _firstScreen;
    this->lastActiveScreen = _lastScreen;
    
};

ScreenPipeline::~ScreenPipeline(){};

void ScreenPipeline::draw(){
    
    //Display all screens in the right order
    if(activeScreen != nullptr) activeScreen->draw();
    if(lastActiveScreen != nullptr) lastActiveScreen->draw();
    
}

void ScreenPipeline::addScreen(shared_ptr<Screen> _screen){
    
    pipeline.push_back(_screen);
    
}

void ScreenPipeline::setScreenActive(shared_ptr<Screen> _screen){
    
    if(activeScreen != nullptr) lastActiveScreen = activeScreen;
    activeScreen = _screen;
    
    activeScreen->setActive(true);
    activeScreen->setAlpha(255);
    activeScreen->setAlphaTarget(255);
    
    if(lastActiveScreen != nullptr) lastActiveScreen->setAlphaTarget(0);
    if(lastActiveScreen != nullptr) lastActiveScreen->setActive(false);
    
}

//Get
shared_ptr<Screen> ScreenPipeline::getActiveScreen(){
    
    return activeScreen;
    
}

shared_ptr<Screen> ScreenPipeline::getLastActiveScreen(){
    
    return lastActiveScreen;
    
}