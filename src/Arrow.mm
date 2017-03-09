//
//  Arrow.mm
//  FLOW
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#include "Arrow.h"

Arrow::Arrow(){
    
    color = ofFloatColor( 255, 255, 255 );
    
}

void Arrow::draw(){
    
    ofPushStyle();
    
    ofSetColor( color );
    ofNoFill();
    
    ofPoint head = getPosition();
    ofPoint tail = getPosition() + (direction.normalize() * length);
    ofPoint firstSide = getPosition() + (direction.normalize() * 30).rotate(45);
    ofPoint secondSide = getPosition() + (direction.normalize() * 30).rotate(-45);
    
    //Main
    
    ofBeginShape();
    
    ofVertex( firstSide );
    ofVertex( head );
    ofVertex( tail );
    ofVertex( head );
    ofVertex( secondSide );
    
    ofEndShape();
    
    ofPopStyle();
    
}

void Arrow::setDirection( ofVec2f _direction ){
    
    direction = _direction;
    
}

void Arrow::setLength( float _length ){
    
    length = _length;
    
}

void Arrow::setColor( ofFloatColor _color ){
    
    color = _color;
    
}

void Arrow::setAlpha( float _alpha ){
    
    color.a = _alpha;
    
}

ofVec2f Arrow::getDirection(){
    
    return direction;
    
}

float Arrow::getLength(){
    
    return length;
    
}

ofFloatColor Arrow::getColor(){
    
    return color;
    
}

float Arrow::getAlpha(){
    
    return color.a;
    
}
