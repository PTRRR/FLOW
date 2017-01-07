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
    
    //Splash screen
    
    splashScreen = shared_ptr<SplashScreen>(new SplashScreen(mainFont));
    splashScreen->setName("SPLASHSCREEN");

    //Menu screen
    
    menu = shared_ptr<Menu>(new Menu(mainFont));
    menu->setName("MENU");
    
    //Levels screen
    
    levels = shared_ptr<Levels>(new Levels(mainFont));
    levels->setName("LEVELS");

    //Screen pipeline setup

    screenPipeline.addScreen(splashScreen);
    screenPipeline.addScreen(menu);
    screenPipeline.addScreen(levels);

    screenPipeline.setScreenActive(splashScreen);
    
};

void GameManager::update(){
    
    if(!initialTimeoutIsOver && ofGetElapsedTimeMillis() >= initialTimeout){
        
        screenPipeline.setScreenActive(menu);
        initialTimeoutIsOver = true;
        
    }
    
    screenPipeline.getActiveScreen()->update();
    
    //Always update the scenes to keep track of the elapsed time in base objects
    
    if(currentScene != nullptr){
        if(screenPipeline.getActiveScreen() != currentScene){
            currentScene->update();
        }
    }
    
}

void GameManager::draw(){
    
    screenPipeline.draw();
    
}

shared_ptr<Scene> GameManager::createNewScene(string _name, string _xmlFile){
    
    shared_ptr<Scene> newScene = shared_ptr<Scene>(new Scene(mainFont));
    newScene->setName(_name);
    newScene->XMLSetup(_xmlFile);
    currentScene = newScene;
    screenPipeline.addScreen(newScene);
    
    return newScene;
    
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
        
        //Check if we are on the levels screen.
        //On the level screen we take directly the action variable as the xml file name used to setup
        //a specific scene.
        
        if (screenPipeline.getActiveScreen() == levels) {
            
            //First we check if some scenes already exists.
            //If not we create one with the level selected by the user.
            //If some scenes already exists then we check if the level selected by the user is alread
            //loaded. If yes juste set that scene active. If not create a new scene and set it active.
            
            if (currentScene != nullptr) {
                
                if(currentScene->getName() == text){
                    
                    currentScene->setPause(false);
                    screenPipeline.setScreenActive(currentScene);
                    
                }else{
                    
                    screenPipeline.removeScreen(currentScene);
                    currentScene = nullptr;
                    screenPipeline.setScreenActive(createNewScene(text, action));
                    
                }
                
            }else{
                
                screenPipeline.setScreenActive(createNewScene(text, action));
                
            }
            
            
        }else{
            
            if(action == "PLAY"){
                
                screenPipeline.setScreenActive(levels);
                
            }else if(action == "MENU"){
                
                if(screenPipeline.getActiveScreen() == currentScene){
                    currentScene->setPause(true);
                }
                
                screenPipeline.setScreenActive(levels);
                
            }else if(action == "EXIT"){
                
                ofExit();
                exit(0);
                
            }
            
        }
    });
    
}

void GameManager::mouseMove(ofVec2f _position){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse move on: " + currentScreen << endl;
    
    screenPipeline.getActiveScreen()->mouseMove(_position, [&](string text, string action){});
    
}












