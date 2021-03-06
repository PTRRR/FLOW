//
//  LevelCreator.hpp
//  FLOW
//
//  Created by Pietro Alberti on 10.01.17.
//
//

#ifndef LevelCreator_hpp
#define LevelCreator_hpp

#include <stdio.h>
#include "BaseElement.h"
#include "Screen.h"
#include "Interface.h"
#include "Polygone.h"
#include "ofxXmlSettings.h"

class LevelCreator : public Screen{
    
private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Interface
    
    Interface interface;
    
    //Rendering
    
    void renderToScreen() override;
    
    //Level creators objects
    
    bool r = false;
    bool v = true;
    bool e = false;
    
    int rows = 30;
    int columns = 23;
    
    long PGCD(long a, long b);
    
    ofVec2f getClosestPoint(ofVec2f _position);
    
    string content;
    string currentXML;
    void printLevel();
    void load();
    void save();
    
    //Game elements
    
    Interface tools;
    float lastTime = 0.0f;
    float timeElapsedSinceDown = 0.0f; //ms
    float timeToDisplayTools = 700.0; //ms
    bool toolsAreDisplayed = false;
    
    bool isDrawing = false;
    bool isErasing = false;
    shared_ptr<ofVec2f> currentTouch;
    vector<ofPolyline> polygones;
    
    void removeLastVertice();
    
    vector<ofVec2f> emitters;
    vector<ofVec2f> receptors;
    
    //Grid
    
    ofVbo gridVbo;
    vector<ofVec3f> gridVertices;
    vector<ofIndexType> gridIndices;
    vector<ofVec2f> points;
    
    //Inputs
    
    bool button = false;
    bool db = false;
    bool down = false;
    ofVec2f touch;
    
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
public:
    
    void setup(string _xmlFile);
    
    LevelCreator();
    LevelCreator(shared_ptr<ofTrueTypeFont> _font);
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* LevelCreator_hpp */
