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
    
    virtual void renderToFbo(){};
    
    //Virtual inputs
    
    virtual void mouseMove(ofVec2f _position){};
    virtual void mouseDrag(ofVec2f _position){};
    virtual void mouseUp(ofVec2f _position){};
    virtual void mouseDown(ofVec2f _position){};
    
    virtual void mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){};
    virtual void mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){};
    virtual void mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){};
    virtual void mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){};
    
protected:
    
    ofFbo fbo;
    ofTexture texture;
    
public:
    
    Screen();
    
    void render();
    void draw();
    virtual void update(){};
    
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
