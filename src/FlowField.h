//
//  FlowField.h
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#ifndef FlowField_h
#define FlowField_h

#include <stdio.h>
#include "ofxiOS.h"
#include "Magnet.h"

struct Item {
    
    ofVec2f position;
    ofVec2f force;
    
    float maxForce;
};

class FlowField {
    
    ofVec2f offset;
    
    int cols;
    int rows;
    
    bool inv = false;
    
    vector<shared_ptr<Item>> field;
    vector<shared_ptr<Magnet>> magnets;
    
public:
    
    FlowField();
    FlowField(int _cols, int _rows);
    ~FlowField();
    
    void update();
    void debugDraw();
    
    void addMagnet(shared_ptr<Magnet> _magnet);
    
    ofVec2f getForceAtPoint(ofVec2f _position);
    
};

#endif /* FlowField_h */
