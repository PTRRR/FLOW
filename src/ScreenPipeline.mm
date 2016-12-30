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

//void ScreenPipeline::updateRenderingOrder(){
//    
//    vector<shared_ptr<Screen>> newPipeline;
//    
//    //Sort the screens
//    //Not wery well done.....
//    while (pipeline.size() > 0) {
//        
//        int currentIndex = 0;
//        int max = -1;
//        
//        for(int i = pipeline.size() - 1; i >= 0; i--){
//            
//            if(pipeline[i]->getIndex() > max){
//                max = pipeline[i]->getIndex();
//                currentIndex = i;
//            }
//            
//        }
//        
//        newPipeline.push_back(pipeline[currentIndex]);
//        pipeline.erase(pipeline.begin() + currentIndex);
//        
//    }
//    
//    //Move the data in the screens array back
//    pipeline = newPipeline;
//    
//}

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