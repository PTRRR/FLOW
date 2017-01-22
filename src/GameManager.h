//
//  GameManager.h
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#ifndef GameManager_h
#define GameManager_h

#include <stdio.h>
#include "ofxiOS.h"
#include "ScreenPipeline.h"
#include "SplashScreen.h"
#include "Menu.h"
#include "Scene.h"
#include "Levels.h"
#include "Options.h"
#include "SceneMenu.h"
#include "NextLevel.h"
#include "End.h"
#include "LevelCreator.h"
#include "LoadLevelsCreator.h"
#include "TestScene.h"
#include "Credits.h"

class GameManager{

private:
    
    shared_ptr<ofTrueTypeFont> mainFont;
    
    //Timer utilitie
    
    int initialTimeout = 5000; //millis
    bool initialTimeoutIsOver = false;
    
    //Screens
    
    ScreenPipeline screenPipeline;
    
    shared_ptr<SplashScreen> splashScreen;
    shared_ptr<Menu> menu;
    shared_ptr<Levels> levels;
    shared_ptr<Options> options;
    shared_ptr<SceneMenu> sceneMenu;
    shared_ptr<NextLevel> nextLevel;
    shared_ptr<End> end;
    shared_ptr<LevelCreator> levelCreator;
    shared_ptr<LoadLevelsCreator> loadLevelsCreator;
    shared_ptr<Credits> credits;
    
    //Test scene is for experimentations
    
    shared_ptr<TestScene> testScene;
    
    //Scenes
    
    string currentLevelFile;
    string nextLevelFile;
    vector<string> levelsList;
    
    shared_ptr<Scene> currentScene;
    void onEnd();
    shared_ptr<Scene> createNewScene(string _name, string _xmlFile);
    
    //Main sound
    
    ofSoundPlayer mainSound;
    
public:
    
    GameManager();
    GameManager(shared_ptr<ofTrueTypeFont> _mainFont);
    
    void update();
    void draw();
    
    //Input
    
    void mouseDown(ofTouchEventArgs & _touch);
    void mouseUp(ofTouchEventArgs & _touch);
    void mouseMove(ofTouchEventArgs & _touch);
    void doubleClick(ofTouchEventArgs & _touch);
    
};

#endif /* GameManager_h */
