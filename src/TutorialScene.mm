//
//  TutorialScene.h
//  ofMagnet
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#include "TutorialScene.h"

TutorialScene::TutorialScene() : Scene(){

    
}

TutorialScene::TutorialScene(shared_ptr<ofTrueTypeFont> _mainFont) : Scene(_mainFont){
    
};

void TutorialScene::update(){
    
    TutorialScene::Scene::update();
    
}
