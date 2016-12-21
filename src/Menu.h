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
    
    //Inputs
    
    void onMouseDown(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseMove(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    void onMouseUp(ofVec2f _position, function<void(string _text, string _action)> callback) override;
    
public:

    Menu();
    Menu(shared_ptr<ofTrueTypeFont> _font);
    
    //Inputs
    
    
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* Menu_h */
