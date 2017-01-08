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

class GameManager {

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
    
    //Scenes
    
    shared_ptr<Scene> currentScene;
//    vector<shared_ptr<Scene>> scenes;
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
    
};

#endif /* GameManager_h */
