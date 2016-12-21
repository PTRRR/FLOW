//
//  GameManager.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#include "GameManager.h"

GameManager::GameManager(){};

GameManager::GameManager(shared_ptr<ofTrueTypeFont> _mainFont){

    mainFont = _mainFont;
    
    splashScreen = shared_ptr<SplashScreen>(new SplashScreen(mainFont));
    splashScreen->setIndex(0);
    
    menu = shared_ptr<Menu>(new Menu(mainFont));
    menu->setIndex(1);
    
    //Screen pipeline setup
    
    screenPipeline.addScreen(splashScreen);
    screenPipeline.addScreen(menu);
    
    screenPipeline.updateRenderingOrder();
    screenPipeline.renderAllScreens();
    
    screenPipeline.setScreenActive(splashScreen);
    
    timer.setTimeout([=](){
    
        cout << "HAHAHAHA" << endl;
        
        
        
    }, 2000);
    
    timer.setTimeout([=](){
        
        cout << ofGetElapsedTimeMillis() << endl;
        
    }, 3000);
    
    
    
};

void GameManager::update(){
    
    timer.update();
    
}

void GameManager::draw(){
    
    screenPipeline.draw();
    
}

//Input

void GameManager::mouseDown(ofVec2f _position){
    
    
    
}

void GameManager::mouseUp(ofVec2f _position){
    
    screenPipeline.getActiveScreen()->mouseUp(_position, [&](string text, string action){
        cout << text << endl;
    });
    
}

void GameManager::mouseMove(ofVec2f _position){
    
    
    
}

void GameManager::mouseDrag(ofVec2f _position){
    
    
    
}












