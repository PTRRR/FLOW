//
//  TutorialScene.h
//  ofMagnet
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#ifndef TutorialScene_h
#define TutorialScene_h

#include <stdio.h>
#include "Scene.h"

class TutorialScene : public Scene{
    
private:
    
    
    
public:
    
    TutorialScene();
    TutorialScene(shared_ptr<ofTrueTypeFont> _mainFont);
    

    void update();
    
};

#endif /* TutorialScene_h */
