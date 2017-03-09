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
    
    shared_ptr<ofTrueTypeFont> textFont;
    Interface tutorialInterface;
    vector<shared_ptr<Text>> texts;
    vector<shared_ptr<Arrow>> arrows;
    
public:
    
    TutorialScene();
    TutorialScene(shared_ptr<ofTrueTypeFont> _mainFont);

    void setup() override;
    void update() override;
    void renderToScreen() override;
    
};

#endif /* TutorialScene_h */
