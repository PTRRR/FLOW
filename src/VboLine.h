//
//  VboLine.h
//  FLOW
//
//  Created by Pietro Alberti on 14.01.17.
//
//

#ifndef VboLine_h
#define VboLine_h

#include <stdio.h>
#include "ofxiOS.h"
#include "ofxTriangle.h"

class VboLine {

private:
    
    int drawMode = 0;
    
    ofVbo vbo;
    vector<ofVec2f> path;
    vector<ofVec3f> vertices;
    vector<ofIndexType> indices;
    vector<ofFloatColor> colors;
    vector<ofVec2f> texCoords;
    
    int offsetLine = 0;
    int currentLineIndex = 0;
    bool isDrawing = false;
    
public:
    
    VboLine();
    VboLine(int _drawMode);

    //Main
    
    void draw();
    void debugDraw();
    
    //Drawing functions.
    
    void begin();
    void end();
    
    void addPoint(float _x, float _y);
    
    //Set
    
    void setDrawMode(int _drawMode);
    
    //Get
    
    int getLineIndex();
    vector<ofVec3f> getLineVertices(int _lineIndex);
    
};

#endif /* VboLine_h */
