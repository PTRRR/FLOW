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
    
    //Set up the scene according to a XML file
    
    scene->XMLSetup("scene_1.xml");
    scene->setPause(true);

    //Screen pipeline setup

    screenPipeline.addScreen(splashScreen);
    screenPipeline.addScreen(menu);
    screenPipeline.addScreen(scene);

    screenPipeline.setScreenActive(splashScreen);
    
};

void GameManager::update(){
    
    if(!initialTimeoutIsOver && ofGetElapsedTimeMillis() >= initialTimeout){
        
        screenPipeline.setScreenActive(menu);
        initialTimeoutIsOver = true;
        
    }
    
    screenPipeline.getActiveScreen()->update();
    
    //Always update the scene to keep track of the elapsed time in base objects
    
    if(screenPipeline.getActiveScreen() != scene){
        scene->update();
    }
    
}

void GameManager::draw(){
    
    screenPipeline.draw();
    
}

//Input

void GameManager::mouseDown(ofVec2f _position){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse down on: " + currentScreen << endl;

    screenPipeline.getActiveScreen()->mouseDown(_position, [&](string text, string action){});
    
}

void GameManager::mouseUp(ofVec2f _position){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse up on: " + currentScreen << endl;
    
    screenPipeline.getActiveScreen()->mouseUp(_position, [&](string text, string action){
        
        if(action == "PLAY"){
            
            scene->setPause(false);
            screenPipeline.setScreenActive(scene);
            
        }else if(action == "MENU"){
            
            scene->setPause(true);
            screenPipeline.setScreenActive(menu);
            
        }else if(action == "EXIT"){
            
            ofExit();
            exit(0);
            
        }
        
    });
    
}

void GameManager::mouseMove(ofVec2f _position){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse move on: " + currentScreen << endl;
    
    screenPipeline.getActiveScreen()->mouseMove(_position, [&](string text, string action){});
    
}












