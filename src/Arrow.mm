//
//  Arrow.mm
//  FLOW
//
//  Created by Pietro Alberti on 09.03.17.
//
//

#include "Arrow.h"

Arrow::Arrow(){
    
    color = ofFloatColor( 1.0, 1.0, 1.0, 1.0 );
    
    line.addVertex(ofPoint(0, 0));
    line.addVertex(ofPoint(0, 0));
    line.addVertex(ofPoint(0, 0));
    line.addVertex(ofPoint(0, 0));
    line.addVertex(ofPoint(0, 0));
    
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
    
    
    line.getVertices()[0] = firstSide;
    line.getVertices()[1] = head;
    line.getVertices()[2] = tail;
    line.getVertices()[3] = head;
    line.getVertices()[4] = secondSide;
    
    line.draw();
    
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
