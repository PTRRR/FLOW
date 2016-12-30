//
//  SplashScreen.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef SplashScreen_h
#define SplashScreen_h

#include <stdio.h>
#include "Screen.h"
#include "Interface.h"

class SplashScreen : public Screen{

private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Interface
    
    Interface interface;
    
    //Rendering
    
    void renderToScreen() override;
    
    //Inputs
    
    void onMouseDown(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    
public:
    
    SplashScreen();
    SplashScreen(shared_ptr<ofTrueTypeFont> _font);
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);

};

#endif /* SplashScreen_h */
