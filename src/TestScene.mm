//
//  TestScene.mm
//  FLOW
//
//  Created by Pietro Alberti on 14.01.17.
//
//

#include "TestScene.h"

TestScene::TestScene(){}

TestScene::TestScene(shared_ptr<ofTrueTypeFont> _mainFont){

    mainFont = _mainFont;
    
    lineShader.load("shaders/lineShader");
    vboLine = VboLine(GL_STATIC_DRAW);
    
    vboLine.setWidth(20);
    vboLine.begin();
    
    int circleDef = 5;
    
    for(int i = 0; i < circleDef; i++){
        
        float angle = M_PI * 2.0 / circleDef * i;
        vboLine.addPoint(cos(angle) * 100 + ofGetWidth() / 2, sin(angle) * 100 + ofGetHeight() / 2);
        
    }
    
    vboLine.close();
    vboLine.end();
    
    vboLine.begin();
    
    for(int i = 0; i < circleDef; i++){
        
        float angle = M_PI * 2.0 / circleDef * i;
        vboLine.addPoint(cos(angle) * 100 + ofGetWidth() / 2 + 200, sin(angle) * 100 + ofGetHeight() / 2 + 200);
        
    }
    
    vboLine.close();
    vboLine.end();

}

void TestScene::update(){
    
    
    
}

void TestScene::renderToScreen(){
    
    lineShader.begin();
    vboLine.draw();
    lineShader.end();
    
}

//Player inputs
//These inputs will only fire when this screen is active

void TestScene::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    

    
}

void TestScene::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    

    
}

void TestScene::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    

    
}

void TestScene::onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    

    
}