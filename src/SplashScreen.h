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
#include "BaseElement.h"

class SplashScreen : public Screen{

private:
    
    //Font
    
    shared_ptr<ofTrueTypeFont> font;
    
    //Title
    
    string title = "FLOW";
    vector<shared_ptr<BaseElement>> letterElements;
    
    //Rendering
    
    void renderToScreen() override;
    
public:
    
    SplashScreen();
    SplashScreen(shared_ptr<ofTrueTypeFont> _font);
    
    void update() override;
    
    //Utils
    
    void setFont(shared_ptr<ofTrueTypeFont> _font);

};

#endif /* SplashScreen_h */
