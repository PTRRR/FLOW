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
    vboLine = VboLine(GL_DYNAMIC_DRAW);
    vboLine.setAutoBuild(false);
    
    vboLine.setWidth(2);
    
    int radius = 50;
    
    for(int j = 0; j < num; j++){
        
        vboLine.begin();
        
        vboLine.setColor(1.0, 1.0, 1.0, 1.0 - (float) j / num);
        
        for(int i = 0; i < 30; i++){
            
            float angle = M_PI * 2.0 / 30 * i;
            vboLine.addPoint(cos(angle) * radius + ofGetWidth() / 2, sin(angle) * radius + ofGetHeight() / 2);
            
        }
        
//        vboLine.close();
        vboLine.end();
        
        radius += 20;
        
    }
    
    vboLine.build();
    vboLine.setVbo();

}

void TestScene::update(){
    
    vector<ofVec2f> line0 = vboLine.getLine(0);
    int radius = 20;
    
    for(int i = 0; i < num; i++){
        
        vector<ofVec2f> line = vboLine.getLine(i);
        vector<ofFloatColor> colors = vboLine.getLineColors(i);
        
        for(int j = 0; j < line.size(); j++){
            
            float angle = M_PI * 2.0 / (line0.size() - 1) * j;
        
            float random = ofNoise(cos(angle) * tan(angle) + ofGetElapsedTimeMillis() * 0.001, 0) * amp;
            
            line[j] = ofVec2f(cos(angle) * (radius + random) + ofGetWidth() / 2, sin(angle) * (radius + random) + ofGetHeight() / 2);
            
            colors[j] = ofFloatColor(1.0, 1.0, 1.0, (random / (amp / 3)) * (1 - (float) i / num));
            
        }
        
        vboLine.updateLineColors(i, colors);
        vboLine.updateLine(i, line);
        
        radius += 10;
        
    }
    
    vboLine.build();
    vboLine.updateVbo();
    
//    for(int i = 0; i < line0.size(); i++){
//        
//        float angle = M_PI * 2.0 / (line0.size() - 1) * i;
//        
//        float firstRandom = ofNoise(ofGetElapsedTimeMillis() * 0.001, 0) * 100;
//        float lastRandom = ofNoise((line0.size() - 1) * 0.05 + ofGetElapsedTimeMillis() * 0.001, 0) * 100;
//        float random = ofNoise(cos(angle) * tan(angle) + ofGetElapsedTimeMillis() * 0.001, 0) * 100;
//        
//        float percent = (float) i / (line0.size() - 1);
//        
////        random += (firstRandom - random) * percent;
////        random += (random - lastRandom) * (1 - percent);
//        
//        line0[i] = ofVec2f(cos(angle) * (radius + random) + ofGetWidth() / 2, sin(angle) * (radius + random) + ofGetHeight() / 2);
//        
//    }
//    
//    vboLine.updateLine(0, line0);
//    vboLine.build();
//    vboLine.updateVbo();
    
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