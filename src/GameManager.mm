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
    splashScreen->setName("SPLASHSCREEN");
    
    menu = shared_ptr<Menu>(new Menu(mainFont));
    menu->setName("MENU");
    
    //Scene test
    scene = shared_ptr<Scene>(new Scene(mainFont));
    scene->setName("SCENE");
    
    //Screen pipeline setup
    
    screenPipeline.addScreen(splashScreen);
    screenPipeline.addScreen(menu);
    screenPipeline.addScreen(scene);
    
    screenPipeline.renderAllScreens();
    screenPipeline.setScreenActive(splashScreen);
    
};

void GameManager::update(){
    
    if(!initialTimeoutIsOver && ofGetElapsedTimeMillis() >= initialTimeout){
        
        screenPipeline.setScreenActive(menu);
        initialTimeoutIsOver = true;
        
    }
    
}

void GameManager::draw(){
    
    screenPipeline.draw();
    
}

//Input

void GameManager::mouseDown(ofVec2f _position){

    
}

void GameManager::mouseUp(ofVec2f _position){
    
    screenPipeline.getActiveScreen()->mouseUp(_position, [&](string text, string action){
        
        string currentScreen = screenPipeline.getActiveScreen()->getName();
        
        if(currentScreen == "MENU"){
            
            if(action == "PLAY"){
                
                screenPipeline.setScreenActive(scene);
                
            }
            
        }
        
    });
    
}

void GameManager::mouseMove(ofVec2f _position){
    
    
    
}

void GameManager::mouseDrag(ofVec2f _position){
    
    
    
}












