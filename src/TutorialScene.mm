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
    
    //Texts
    
    shared_ptr<Text> newText = tutorialInterface.addText("THESE ARE MAGNETS", ofVec2f(ofGetWidth() * 0.5, 290));
    texts.push_back(newText);
    newText->setColor(ofFloatColor(255, 255, 255));
    
//    newText = tutorialInterface.addText("TRY TO GRAB ONE AND DRAG IT TO THE CENTER", ofVec2f(ofGetWidth() * 0.5, 290));
//    texts.push_back(newText);
//    newText->setColor(ofFloatColor(255, 255, 255, 0.0));
//    
//    newText = tutorialInterface.addText("TRY TO RESIZE THE MAGNET", ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + 600));
//    texts.push_back(newText);
//    newText->setColor(ofFloatColor(255, 255, 255, 0.0));
    
    //Arrows
    
    shared_ptr<Arrow> newArrow = tutorialInterface.addArrow( ofVec2f( ofGetWidth() * 0.5, 150 ), ofVec2f( 0, 1 ), 60.0 );
    arrows.push_back(newArrow);
    newArrow->setColor( ofFloatColor( 255, 255, 255, 1 ) );
    
    newArrow = tutorialInterface.addArrow( ofVec2f( ofGetWidth() * 0.5, 150 ), ofVec2f( 0, 1 ), 60.0 );
    arrows.push_back(newArrow);
    newArrow->setColor( ofFloatColor( 255, 255, 255, 1 ) );
    
};

void TutorialScene::setup(){
    
    //Set all receptors invisible
    
    for(int i = 0; i < receptors.size(); i++){
        
        receptors[i]->disable(true);
        receptors[i]->setMaxParticles(INFINITY);
        receptors[i]->enable(false);
        receptors[i]->setAlpha(0.0);
        
    }
    
    // Set all emitter to off
    
    for(int i = 0; i < emitters.size(); i++){
        
        emitters[i]->setRate(0);
        emitters[i]->setAlpha(0.0);
        
    }
    
    //Reset timer
    
    elapsedTime = 0;
    time = ofGetElapsedTimeMillis();
    lastTime = time;
    
}

void TutorialScene::update(){
    
    TutorialScene::Scene::update();
    
    float mA = getAlpha() / 255.0;
    
    time = ofGetElapsedTimeMillis();
    float deltaTime = time - lastTime;
    elapsedTime += deltaTime;
    
    //Timer
    
    if(elapsedTime < 2000 && tutorialStep < 1){
        
        tutorialStep = 0;
        
    }else if(elapsedTime > 2000 && elapsedTime < 4000 && tutorialStep < 2){
        
        tutorialStep = 1;
        
    }
    
    //Steps
    
    if(tutorialStep == 0){
        
        texts[0]->setText("THESE ARE MAGNETS");
        texts[0]->setAlpha(1.0 * mA);
        arrows[0]->setPosition(arrows[0]->getPosition() + ofVec2f(0.0, cos(time * 0.005)));
        arrows[0]->setAlpha(1.0 * mA);
        arrows[1]->setAlpha(0.0 * mA);
        
        
    }else if(tutorialStep == 1){
        
        arrows[0]->setPosition(arrows[0]->getPosition() + ofVec2f(0.0, cos(time * 0.005)));
        texts[0]->setText("TRY TO GRAB ONE AND DRAG IT TO THE CENTER");
        texts[0]->setAlpha(1.0 * mA);
        arrows[0]->setAlpha(1.0 * mA);
        arrows[1]->setAlpha(0.0 * mA);
        
    }else if(tutorialStep == 2){
        
        texts[0]->setAlpha(1.0 * mA);
        texts[0]->setPosition(ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + 500));
        
        arrows[0]->setDirection(ofVec2f(1, 0));
        arrows[0]->setPosition(arrows[0]->getPosition() + ofVec2f(cos(time * 0.005), 0.0));
        arrows[1]->setDirection(ofVec2f(-1, 0));
        arrows[1]->setPosition(arrows[1]->getPosition() + ofVec2f(cos(time * 0.005 + M_PI), 0.0));
        
        arrows[0]->setAlpha(1.0 * mA);
        arrows[1]->setAlpha(1.0 * mA);
        
    }else if(tutorialStep == 3){
        
        texts[0]->setAlpha(1.0 * mA);
        arrows[0]->setAlpha(0.0 * mA);
        arrows[1]->setAlpha(0.0 * mA);
        
    }else if(tutorialStep == 4){
        
        arrows[0]->setAlpha(1.0 * mA);
        
    }
    
    lastTime = time;
    
}

void TutorialScene::renderToScreen(){
    
    TutorialScene::Scene::renderToScreen();
    
    ofEnableAlphaBlending();
    
    tutorialInterface.draw();
    
    ofDisableAlphaBlending();
    
}

void TutorialScene::onMouseDown(ofTouchEventArgs &_touch, function<void (string, string)> _callback){
    
    TutorialScene::Scene::onMouseDown(_touch, _callback);
    
    lastTouch = _touch;
    
}

void TutorialScene::onMouseUp(ofTouchEventArgs &_touch, function<void (string, string)> _callback){
    
    TutorialScene::Scene::onMouseUp(_touch, _callback);
    
    if(tutorialStep == 0 || tutorialStep == 1){
        
        for(int i = 0; i < actuators.size(); i++){
            
            if((actuators[i]->getPosition() - ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2)).length() < 200.0){
                
                tutorialStep = 2;
                texts[0]->setText("TRY TO RESIZE THE MAGNET");
                arrows[1]->setPosition(ofVec2f(ofGetWidth() - 200, ofGetHeight() / 2));
                arrows[0]->setPosition(ofVec2f(200, ofGetHeight() / 2));
                
            }
            
        }
        
    }else if(tutorialStep == 2){
        
        for(int i = 0; i < actuators.size(); i++){
            
            if(actuators[i]->getRadius() > 200){
                
                for(int i = 0; i < emitters.size(); i++){
                    
                    emitters[i]->setRate(50);
                    emitters[i]->setAlpha(1.0);
                    
                }
                
                tutorialStep = 3;
                texts[0]->setText("MOVE THE MAGNET AROUND AND SEE HOW IT INTERACTS WITH PARTICLES");
                break;
                
            }
            
            if(i == actuators.size() - 1){
                
                texts[0]->setText("TRY TO RESIZE IT A BIT MORE");
                
            }
            
        }
        
    }else if(tutorialStep == 3){
        
        cout << movedLength << endl;
        
        if(movedLength > 700){
            
            texts[0]->setText("WITH THE HELP OF THE MAGNETS TRY TO PUT AS MANY PARTICLES IN THE RECEPTOR BELOW");
            arrows[0]->setPosition(ofVec2f(ofGetWidth() / 2, 300));
            
            tutorialStep = 4;
            
            for(int i = 0; i < receptors.size(); i++){
                
                receptors[i]->disable(false);
                receptors[i]->setMaxParticles(300);
                receptors[i]->enable(true);
                receptors[i]->setAlpha(1.0);
                
            }
            
        }else if(movedLength < 700){
            
            texts[0]->setText("TRY TO MOVE IT A BIT MORE");
            
        }
        
    }
    
}

void TutorialScene::onMouseMove(ofTouchEventArgs &_touch, function<void (string, string)> _callback){
    
    TutorialScene::Scene::onMouseMove(_touch, _callback);
    
    if(tutorialStep == 3){
        
        deltaMove = (_touch - lastTouch).length();
        
        
        for(int i = 0; i < actuators.size(); i++){
            
            if(actuators[i]->isOver(_touch)){
                
                movedLength += deltaMove;
                break;
                
            }
            
        }
        
        lastTouch = _touch;
        
    }
    
}
