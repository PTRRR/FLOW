//
//  Receptor.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#include "Receptor.h"

Receptor::Receptor(){
    
    count = 0;
    
};

void Receptor::display(){
    
    ofPushStyle();
    ofSetColor(255, 255, 255);
    ofDrawCircle(position, radius);
    ofPopStyle();
    
}

//Set
void Receptor::setRadius(float _radius){
    
    this->radius = _radius;
    
}

void Receptor::setPosition(ofVec2f _position){
    
    BaseElement::setPosition(_position);
    
}

void Receptor::setCount(int _count){
    
    count = _count;
    
}

//Get
float Receptor::getRadius(){
    
    return radius;
    
}

int Receptor::getCount(){
    
    return count;
    
}
