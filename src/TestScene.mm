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
    
    vboLine.begin();
    
    vboLine.addPoint(30, ofGetHeight() / 2);
    vboLine.setLineWidth(20);
    vboLine.setColor(1.0, 0, 0);
    vboLine.addPoint(ofGetWidth() / 2 - 200, ofGetHeight() / 2);
    vboLine.setLineWidth(30);
    vboLine.addPoint(ofGetWidth() / 2, ofGetHeight() / 2 - 200);
    vboLine.setLineWidth(20);
    vboLine.addPoint(ofGetWidth() / 2 + 200, ofGetHeight() / 2);
    vboLine.setLineWidth(10);
    vboLine.setColor(1.0, 1.0, 1.0);
    vboLine.addPoint(ofGetWidth() - 30, ofGetHeight() / 2);
    
    vboLine.end();

}

void TestScene::update(){
    
    
    
}

void TestScene::renderToScreen(){
    
    ofSetColor(255, 255, 255);
    
    
    lineShader.begin();
    vboLine.draw();
    lineShader.end();
//    vboLine.debugDraw();
    
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