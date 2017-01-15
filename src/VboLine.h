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
    
    //Properties
    
    float lastLineWidth;
    float lineWidth = 10.0;
    ofFloatColor lastColor;
    ofFloatColor color = ofFloatColor(1.0, 1.0, 1.0, 1.0);
    
    int drawMode = 0;
    
    vector<ofVec2f> path;
    
    ofVbo vbo;
    vector<ofVec3f> vertices;
    vector<ofIndexType> indices;
    vector<ofFloatColor> colors;
    vector<ofVec2f> texCoords;
    
    vector<int> linesLength;
    
    int offsetVertices = 0;
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
    void close();
    
    void computeLine(int _lineIndex);
    void computeLines();
    
    //Set
    
    void setColor(float _r, float _g, float _b);
    void setColor(float _r, float _g, float _b, float _a);
    void setWidth(float _width);
    void setDrawMode(int _drawMode);
    
    void updateLineVertices(int _lineIndex, vector<ofVec2f> _newLine);
    void updateLineColors(int _lineIndex, vector<ofFloatColor> _newColors);
    
    //Get
    
    int getLineIndex();
    vector<ofVec2f> getLine(int _lineIndex);
    
};

#endif /* VboLine_h */
