//
//  TutorialScene.h
//  ofMagnet
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#include "TutorialScene.h"

TutorialScene::TutorialScene() : Scene(){}

TutorialScene::TutorialScene(shared_ptr<ofTrueTypeFont> _mainFont) : Scene(_mainFont){

    textFont = shared_ptr<ofTrueTypeFont>(new ofTrueTypeFont());
    textFont->load("GT-Pressura-Mono-Light.ttf", 20);
    tutorialInterface = Interface(textFont);
    
    shared_ptr<Text> newText = tutorialInterface.addText("THESE ARE MAGNETS", ofVec2f(ofGetWidth() * 0.5, 290));
    texts.push_back(newText);
    newText->setColor(ofFloatColor(255, 255, 255));
    
    shared_ptr<Arrow> newArrow = tutorialInterface.addArrow( ofVec2f( ofGetWidth() * 0.5, 150 ), ofVec2f( 0, 1 ), 60.0 );
    arrows.push_back(newArrow);
    newArrow->setColor( ofFloatColor( 255, 255, 255 ) );
    
};

void TutorialScene::setup(){
    
    // Set all emitter to off
    
    for(int i = 0; i < emitters.size(); i++){
        
        emitters[i]->setRate(0);
        
        cout << "asdélkj" << endl;
        
    }
    
    
    
}

void TutorialScene::update(){
    
    TutorialScene::Scene::update();
    
    for(int i = 0; i < texts.size(); i++){
        
        texts[i]->setAlpha( getAlpha() / 255.0 );
        
    }
    
}

void TutorialScene::renderToScreen(){
    
    TutorialScene::Scene::renderToScreen();
    
    tutorialInterface.draw();
    
}
