//
//  FlowField.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#include "FlowField.h"

FlowField::FlowField(){};

FlowField::FlowField(int _cols, int _rows){
    
    cols = _cols;
    rows = _rows;
    
    int numItems = cols * rows;
    
    for(int i = 0; i < numItems; i++){
        
        shared_ptr<Item> newItem(new Item());
        newItem->position = ofVec2f((i % cols) * ofGetWidth() / cols + (ofGetWidth() / cols / 2), (i / cols) * ofGetHeight() / rows + (ofGetHeight() / rows / 2));
        newItem->force = ofVec2f(0.0f, 0.0f);
        newItem->maxForce = min(ofGetWidth() / cols, ofGetHeight() / rows);
        
        field.push_back(newItem);
        
    }
    
}

FlowField::~FlowField(){};

void FlowField::update(){
    
    
    
}

void FlowField::debugDraw(){
    
//    gl::color(0.25f, 0.25f, 0.25f);
//    gl::begin(GL_LINES);
//    
//    gl::ScopedBlendAdditive blend;
//    
//    for(int i = 0; i < field.size(); i++){
//        
//        shared_ptr<Item> cI = field[i];
//        
//        vec2 force = getForceAtPoint(cI->position) * 35.0f;
//        //        if(glm::length(force) > 20.0) force = glm::normalize(force) * 20.0f;
//        
//        gl::vertex(cI->position);
//        gl::vertex(cI->position + force);
//        
//        vec2 origin = cI->position + force;
//        float radius = 3.0f;
//        int cDef = 3;
//        float step = 2 * M_PI / cDef;
//        float offsetAngle = atan2(force.y, force.x);
//        
//        for(int v = 1; v < cDef + 1; v++){
//            
//            vec2 lPoint = vec2(cos((v - 1) * step + offsetAngle) * radius, sin((v - 1) * step + offsetAngle) * radius);
//            vec2 cPoint = vec2(cos(v * step + offsetAngle) * radius, sin(v * step + offsetAngle) * radius);
//            
//            gl::vertex(origin + lPoint);
//            gl::vertex(origin + cPoint);
//            
//        }
//    }
//    
//    gl::end();
    
}

void FlowField::addMagnet(shared_ptr<Magnet> _magnet){
    
    magnets.push_back(_magnet);
    
}

ofVec2f FlowField::getForceAtPoint(ofVec2f _position){
    
    ofVec2f force = ofVec2f(0.0);
    
    for(int i = 0; i < magnets.size(); i++){
        
        float strength = magnets[i]->getStrength();
        ofVec2f direction = _position - magnets[i]->getPosition();
        float dist = direction.length();
        
        float percent = 1 - (dist / magnets[i]->getRadiusOfAction());
        percent = ofClamp(percent, 0.0f, 1.0f);
        
        force += direction.normalize() * strength * percent;
        
    }
    
    return force;
    
}