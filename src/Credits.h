//
//  Credits.h
//  FLOW
//
//  Created by Pietro Alberti on 22.01.17.
//
//

#ifndef Credits_h
#define Credits_h

#include <stdio.h>
#include "Screen.h"
#include "Interface.h"

class Credits : public Screen{
    
private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Interface
    
    Interface title;
    Interface credits;
    
    string creditsLines[7];
    string creditsString;
    
    shared_ptr<ofTrueTypeFont> renensLight;
    shared_ptr<ofTrueTypeFont> renensMedium;
    ofImage ecalLogo;
    
    //Rendering
    
    void renderToScreen() override;
    
    //Inputs
    
    void onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback) override;
    
public:
    
    Credits();
    Credits(shared_ptr<ofTrueTypeFont> _font);
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);
    
};

#endif /* Credits_h */
