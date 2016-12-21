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
    
};

void GameManager::draw(){
    
    screenPipeline.draw();
    
}

//Input

void GameManager::mouseDown(ofVec2f _position){
    
    menu->mouseDown(_position, [&](string text, string action){
        cout << text << endl;
    });
    
}