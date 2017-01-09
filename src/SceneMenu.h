//
//  SceneMenu.h
//  FLOW
//
//  Created by Pietro Alberti on 08.01.17.
//
//

#ifndef SceneMenu_h
#define SceneMenu_h

#include <stdio.h>
#include "Screen.h"
#include "Interface.h"

class SceneMenu : public Screen{
    
private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Interface
    
    Interface interface;
    
    //Rendering
    
    void renderToScreen() override;
    
    //Inputs
    
    void onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
public:
    
    SceneMenu();
    SceneMenu(shared_ptr<ofTrueTypeFont> _font);
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* SceneMenu_h */
