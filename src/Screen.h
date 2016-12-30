//
//  Screen.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef Screen_h
#define Screen_h

#include <stdio.h>
#include "ofxiOS.h"

class Screen {

private:
    
    float w;
    float h;
    float alpha;
    float alphaTarget;
    
    float zIndex;
    string name = "screen";
    
    bool active;
    
    virtual void renderToScreen(){};
    
    //Virtual inputs
    
    virtual void onMouseDown(ofVec2f _position, function<void(string _text, string _action)> _callback){};
    virtual void onMouseMove(ofVec2f _position, function<void(string _text, string _action)> _callback){};
    virtual void onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> _callback){};
    virtual void onMouseUp(ofVec2f _position, function<void(string _text, string _action)> _callback){};
    
public:
    
    Screen();

    void draw();
    virtual void update(){};
    
    //Inputs
    
    void mouseDown(ofVec2f _position, function<void(string _text, string _action)> _callback);
    void mouseMove(ofVec2f _position, function<void(string _text, string _action)> _callback);
    void mouseDrag(ofVec2f _position, function<void(string _text, string _action)> _callback);
    void mouseUp(ofVec2f _position, function<void(string _text, string _action)> _callback);
    
    //Set
    void setAlpha(float _alpha);
    void setAlphaTarget(float _alphaTarget);
    void setIndex(int _index);
    void setActive(bool _active);
    void setName(string _name);
    
    //Get
    float getAlpha();
    bool isVisible();
    int getIndex();
    bool isActive();
    string getName();
    
};

#endif /* Screen_h */
