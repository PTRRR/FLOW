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
    if(lastActiveScreen != nullptr) lastActiveScreen->draw();
    if(activeScreen != nullptr) activeScreen->draw();
    
}

void ScreenPipeline::addScreen(shared_ptr<Screen> _screen){
    
    pipeline.push_back(_screen);
    
    //Each time a screen is added update the rendering order
    pipeline[pipeline.size() - 1]->render();
    updateRenderingOrder();
    
}

void ScreenPipeline::updateRenderingOrder(){
    
    vector<shared_ptr<Screen>> newPipeline;
    
    //Sort the screens
    //Not wery well done.....
    while (pipeline.size() > 0) {
        
        int currentIndex = 0;
        int max = -1;
        
        for(int i = pipeline.size() - 1; i >= 0; i--){
            
            if(pipeline[i]->getIndex() > max){
                max = pipeline[i]->getIndex();
                currentIndex = i;
            }
            
        }
        
        newPipeline.push_back(pipeline[currentIndex]);
        pipeline.erase(pipeline.begin() + currentIndex);
        
    }
    
    //Move the data in the screens array back
    pipeline = newPipeline;
    
}

void ScreenPipeline::renderAllScreens(){
    
    for(int i = pipeline.size() - 1; i >= 0; i--){
        pipeline[i]->render();
    }
    
}

void ScreenPipeline::renderCurrentScreens(){
    
    for(int i = pipeline.size() - 1; i >= 0; i--){
        
        if(pipeline[i]->isVisible()){
            
            //Draw the current screen and the one behind
            if(i - 1 >= 0) pipeline[i - 1]->render();
            pipeline[i]->render();
            break;
            
        }
    }
    
}

void ScreenPipeline::setScreenActive(shared_ptr<Screen> _screen){
    
    _screen->setActive(true);
    
    for(int i = pipeline.size() - 1; i >= 0; i--){
        
        if(pipeline[i] != _screen){
            
            pipeline[i]->setAlphaTarget(0.0f);
            pipeline[i]->setActive(false);
            
        }else{
            
            pipeline[i]->setAlphaTarget(1.0f);
            pipeline[i]->setActive(true);
            
        }
        
    }
    
    lastActiveScreen = activeScreen;
    activeScreen = _screen;
    
}

//Get
shared_ptr<Screen> ScreenPipeline::getActiveScreen(){
    
    return activeScreen;
    
}

shared_ptr<Screen> ScreenPipeline::getLastActiveScreen(){
    
    return lastActiveScreen;
    
}