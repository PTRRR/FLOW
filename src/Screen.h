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
#include "ofxXmlSettings.h"

class Screen {

private:
    
    float w;
    float h;
    float mainAlpha;
    float alphaTarget;
    
    float zIndex;
    string name = "screen";
    
    bool active;
    
    virtual void renderToScreen(){};
    float alpha(float _alpha);
    
    //Virtual inputs
    
    virtual void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){};
    virtual void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){};
    virtual void onMouseDrag(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){};
    virtual void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){};
    
    ofFbo fbo;
    
public:
    
    Screen();

    void draw();
    virtual void update(){};
    
    //Inputs
    
    void mouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback);
    void mouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback);
    void mouseDrag(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback);
    void mouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback);
    
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
    
    //XML
    
    void saveXML(string _name, ofxXmlSettings _XML);
    void loadXML(string _xmlFile, function<void(ofxXmlSettings _XML)> _callback);
    void logXML(string _fileName);
    bool XMLExists(string _xmlName);
    
};

#endif /* Screen_h */
