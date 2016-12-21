//
//  Menu.h
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#ifndef Menu_h
#define Menu_h

#include <stdio.h>
#include "Screen.h"
#include "Interface.h"

class Menu : public Screen{

private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Interface
    
    Interface interface;
    
    //Rendering
    
    void renderToFbo() override;
    
public:

    Menu();
    Menu(shared_ptr<ofTrueTypeFont> _font);
    
    //Inputs
    
    void mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* Menu_h */
