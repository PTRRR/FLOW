//
//  End.h
//  FLOW
//
//  Created by Pietro Alberti on 09.01.17.
//
//

#ifndef End_h
#define End_h

#include <stdio.h>

#include "Screen.h"
#include "Interface.h"

class End : public Screen{
    
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
    
    End();
    End(shared_ptr<ofTrueTypeFont> _font);
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* End_h */
