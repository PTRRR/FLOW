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
    
    bool autoBuild = true;
    
    //Properties
    
    float lastLineWidth;
    float lineWidth = 10.0;
    ofFloatColor lastColor;
    ofFloatColor color = ofFloatColor(1.0, 1.0, 1.0, 1.0);
    
    int drawMode = 0;
    
    int currentLineIndex = 0;
    vector<int> linesLength;
    vector<ofVec2f> path;
    vector<bool> pathClosed;
    vector<float> pathRadiuses;
    vector<ofFloatColor> pathColors;
    
    ofVbo vbo;
    vector<ofVec3f> vertices;
    vector<ofIndexType> indices;
    vector<ofFloatColor> colors;
    vector<ofVec2f> texCoords;
    
    int offsetVertices = 0;
    int offsetLine = 0;
    
    bool isDrawing = false;
    
    ofShader shader;
    
public:
    
    VboLine();
    VboLine(int _drawMode);

    //Main
    
    void draw();
    void drawShaded();
    void debugDraw();
    
    //Drawing functions.
    
    void begin();
    void end();
    
    void addPoint(float _x, float _y);
    void close();
    
    void build();
    void setVbo();
    void updateVbo();
    
    void clear();
    
    //Set
    
    void setColor(float _r, float _g, float _b);
    void setColor(float _r, float _g, float _b, float _a);
    void setWidth(float _width);
    void setDrawMode(int _drawMode);
    void setAutoBuild(bool _autoBuild);
    
    void updateLine(int _lineIndex, vector<ofVec2f> _newLine);
    void updateLineColors(int _lineIndex, vector<ofFloatColor> _newColors);
    void updateLineRadiuses(int _lineIndex, vector<ofFloatColor> _newRadiuses);
    
    //Get
    
    int getLineNum();
    int getLineIndex();
    vector<ofVec2f> getLine(int _lineIndex);
    vector<ofFloatColor> getLineColors(int _lineIndex);
    
};

#endif /* VboLine_h */
