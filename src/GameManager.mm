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
    
    //Options screen
    
    options = shared_ptr<Options>(new Options(mainFont));
    options->setName("OPTIONS");
    
    //Scene menu screen
    
    sceneMenu = shared_ptr<SceneMenu>(new SceneMenu(mainFont));
    sceneMenu->setName("SCENE-MENU");
    
    //Next level screen
    
    nextLevel = shared_ptr<NextLevel>(new NextLevel(mainFont));
    nextLevel->setName("NEXT-LEVEL");
    
    //End screen
    
    end = shared_ptr<End>(new End(mainFont));
    end->setName("END");

    //Screen pipeline setup

    screenPipeline.addScreen(splashScreen);
    screenPipeline.addScreen(menu);
    screenPipeline.addScreen(levels);
    screenPipeline.addScreen(sceneMenu);
    screenPipeline.addScreen(options);
    screenPipeline.addScreen(nextLevel);
    screenPipeline.addScreen(end);

    screenPipeline.setScreenActive(splashScreen);
    
    //Main sound
    
    mainSound.load("sounds/main.mp3");
    mainSound.setLoop(true);
    mainSound.setVolume(0);
    mainSound.play();
    
};

void GameManager::update(){
    
    if(!initialTimeoutIsOver && ofGetElapsedTimeMillis() >= initialTimeout){
        
        screenPipeline.setScreenActive(menu);
        initialTimeoutIsOver = true;
        
    }
    
    //First fade in volume.
    
    if(mainSound.getVolume() < 1){
     
        mainSound.setVolume(mainSound.getVolume() + 0.003);
        
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

//Scene

shared_ptr<Scene> GameManager::createNewScene(string _name, string _xmlFile){
    
    shared_ptr<Scene> newScene = shared_ptr<Scene>(new Scene(mainFont));
    newScene->setName(_name);
    newScene->XMLSetup(_xmlFile);
    currentScene = newScene;
    screenPipeline.addScreen(newScene);
    
    return newScene;
    
}

//This function will be triggered every times the players finish a level.

void GameManager::onEnd(){
    
    //If the scene is completed return to levels.
    
    currentScene->onEnd([&](){
        
        levelsList = levels->getLevels();
        
        for(int i = 0; i < levelsList.size(); i++){
            
            if (levelsList[i] == currentLevelFile && i < levelsList.size() - 2) {
                
                nextLevelFile = levelsList[i + 1];
                levels->setUnlocked(nextLevelFile);
                levels->setup();
                screenPipeline.setScreenActive(nextLevel);
                break;
                
            }else if(i == levelsList.size() - 1){
                screenPipeline.setScreenActive(end);
            }
            
        }
        
    });
    
}

//Input

void GameManager::mouseDown(ofTouchEventArgs & _touch){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse down on: " + currentScreen << endl;
    
    screenPipeline.getActiveScreen()->mouseDown(_touch, [&](string text, string action){});
    
}

void GameManager::mouseUp(ofTouchEventArgs & _touch){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse up on: " + currentScreen << endl;
    
    screenPipeline.getActiveScreen()->mouseUp(_touch, [&](string text, string action){
        
        //Check if we are on the levels screen.
        //On the level screen we take directly the action variable as the xml file name used to setup
        //a specific scene.
        
        if (screenPipeline.getActiveScreen() == levels) {
            
            if(action == "BACK"){
                
                if(screenPipeline.getLastActiveScreen() == currentScene && !currentScene->isFinished()){
                    
                    screenPipeline.setScreenActive(sceneMenu);
                    
                }else{
                    
                    screenPipeline.setScreenActive(menu);
                    
                }
                
            }else{
                
                //First we check if some scenes already exists.
                //If not we create one with the level selected by the user.
                //If some scenes already exists then we check if the level selected by the user is alread
                //loaded. If yes juste set that scene active. If not create a new scene and set it active.
                
                if (currentScene != nullptr) {
                    
                    //If the scene selectet is the same of the current one and if the current one is not finished.
                    
                    if(currentScene->getName() == text && !currentScene->isFinished()){
                        
                        //Restore the previous scene not ended
                        
                        currentScene->setPause(false);
                        screenPipeline.setScreenActive(currentScene);
                        
                    }else{
                        
                        //Create a new scene if the scene selected is not the current one.
                        
                        screenPipeline.removeScreen(currentScene);
                        currentScene = nullptr;
                        
                        currentLevelFile = action;
                        screenPipeline.setScreenActive(createNewScene(text, action));
                    
                        //Sets the callback function triggered once this scene will be finished.
                        
                        onEnd();
                        
                    }
                    
                }else{
                    
                    //Create a new scene if none has been previously set.
                    
                    currentLevelFile = action;
                    screenPipeline.setScreenActive(createNewScene(text, action));
                    
                    //Sets the callback function triggered once this scene will be finished.
                    
                    onEnd();
                    
                }
                
            }
            
        }else{
            
            if(action == "PLAY"){
                
                //This check is others levels have been unlocked.
                
                levels->setup();
                screenPipeline.setScreenActive(levels);
                
            }else if(action == "MENU"){
                
                if(screenPipeline.getActiveScreen() == currentScene){
                    currentScene->setPause(true);
                }
                
                screenPipeline.setScreenActive(levels);
                
            }else if(action == "EXIT"){
                
                ofExit();
                exit(0);
                
            }else if(action == "BACK"){
                
                screenPipeline.setScreenActive(menu);
                
            }else if(action == "SCENE-MENU"){
                
                currentScene->setPause(true);
                screenPipeline.setScreenActive(sceneMenu);
                
            }else if(action == "OPTIONS"){
                
                currentScene->setPause(true);
                screenPipeline.setScreenActive(options);
                
            }else if(action == "RESUME"){
                
                if (currentScene != nullptr) {
                    
                    currentScene->setPause(false);
                    screenPipeline.setScreenActive(currentScene);
                    
                }
                
            }else if(action == "NEXT-LEVEL"){
                
                screenPipeline.setScreenActive(createNewScene("nextLevel", nextLevelFile));
                
            }else if(action == "RESTART"){
                
                screenPipeline.setScreenActive(createNewScene("currentLevel", currentLevelFile));
                
            }
            
        }
    });
    
}

void GameManager::mouseMove(ofTouchEventArgs & _touch){
    
    string currentScreen = screenPipeline.getActiveScreen()->getName();
    cout << "mouse move on: " + currentScreen << endl;
    
    screenPipeline.getActiveScreen()->mouseMove(_touch, [&](string text, string action){});
    
}












