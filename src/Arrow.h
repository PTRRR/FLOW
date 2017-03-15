//
//  Arrow.h
//  FLOW
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#ifndef Arrow_h
#define Arrow_h

#include "BaseElement.h"
#include <stdio.h>

class Arrow : public BaseElement {

private:
    
    ofVec2f direction;
    float length;
    ofFloatColor color;
    ofPolyline line;
    
public:
    
    Arrow();
    
    void draw();
    
    //Set
    
    void setDirection( ofVec2f _direction );
    void setLength( float _length );
    void setColor( ofFloatColor _color );
    void setAlpha( float _alpha );
    
    //Get
    
    ofVec2f getDirection();
    float getLength();
    ofFloatColor getColor();
    float getAlpha();
    
};

#endif /* Arrow_h */
