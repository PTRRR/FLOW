//
//  VboLine.mm
//  FLOW
//
//  Created by Pietro Alberti on 14.01.17.
//
//

#include "VboLine.h"

VboLine::VboLine(){
    
    drawMode = GL_STATIC_DRAW;
    vbo.clear();
    
}

VboLine::VboLine(int _drawMode){
    
    drawMode = _drawMode;
    vbo.clear();
    
}

void VboLine::draw(){
    
    vbo.drawElements(GL_TRIANGLES, (int) indices.size());
    
}

void VboLine::debugDraw(){
    
    ofPushStyle();
    
    ofSetColor(0, 255, 0);
    ofNoFill();
    
    if(path.size() > 0){
        
        ofBeginShape();
        
        for(int i = 1; i < path.size(); i++){
            
            ofVertex(path[i - 1].x, path[i - 1].y);
            ofVertex(path[i].x, path[i].y);
            
        }
        
        ofEndShape();
        
    }
    
    ofSetColor(255, 0, 0);
    ofFill();
    
    for(int i = 0; i < vertices.size(); i++){
        
        ofDrawCircle(vertices[i].x, vertices[i].y, 5);
        
    }
    
    ofPopStyle();
        
}

void VboLine::begin(){
    
    isDrawing = true;
    
}

void VboLine::end(){
    
    isDrawing = false;
    currentLineIndex ++;
    linesLength.push_back(path.size() - offsetLine);
    cout << linesLength[0] << endl;
    offsetVertices = vertices.size();
    offsetLine = path.size();
    
    
}

void VboLine::addPoint(float _x, float _y){
    
    if(!isDrawing) return;
    
    path.push_back(ofVec2f(_x, _y));
    
    computeLines();
    
    vbo.setVertexData(&vertices[0], (int)vertices.size(), drawMode);
    vbo.setIndexData(&indices[0], (int) indices.size(), drawMode);
    vbo.setColorData(&colors[0], (int) colors.size(), drawMode);
    vbo.setTexCoordData(&texCoords[0], (int) texCoords.size(), drawMode);
    
    lastLineWidth = lineWidth;
    lastColor = color;
    
}

void VboLine::close(){
    
    if(!isDrawing && path.size() - offsetLine <= 1) return;
    
    addPoint(path[offsetLine].x, path[offsetLine].y);
    
    ofVec2f lastLastPoint = path[path.size() - 2];
    ofVec2f lastPoint = path[offsetLine];
    ofVec2f currentPoint = path[offsetLine + 1];
    
    ofVec2f lastNormal = (lastPoint - lastLastPoint).getPerpendicular();
    ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
    
    //Recalculate last line cap.
    
    ofVec2f recalculatedNormal = (lastNormal + normal).normalize();
    
    float amp = lastLineWidth / cos(lastNormal.angleRad(recalculatedNormal));
    
    vertices[vertices.size() - 3] = lastPoint + recalculatedNormal * amp * 0.5;
    vertices[vertices.size() - 2] = lastPoint - recalculatedNormal * amp * 0.5;
    
    vertices[offsetVertices] = lastPoint + recalculatedNormal * amp * 0.5;
    vertices[offsetVertices + 3] = lastPoint - recalculatedNormal * amp * 0.5;
    
    vbo.setVertexData(&vertices[0], (int)vertices.size(), drawMode);
    vbo.setIndexData(&indices[0], (int) indices.size(), drawMode);
    vbo.setColorData(&colors[0], (int) colors.size(), drawMode);
    vbo.setTexCoordData(&texCoords[0], (int) texCoords.size(), drawMode);
    
}

void VboLine::computeLines(){
    
    int offset = 0;
    
    for(int i = 0; i < linesLength.size(); i++){
        
        for(int j = 0; j < linesLength[i]; j++){
            
            
            
        }
        
        offset += linesLength[i];
        
    }
    
    if(path.size() - offsetLine == 2){ //Two points
        
        //Add one point and calculate mesh according to the normal
        //of the first segment and the current line width.
        //We have to know the position of the last point to get the normal.
        //The normal is the perpendicular vector to the vector pointing from the point just added
        //toward the last point.
        
        ofVec2f lastPoint = path[path.size() - 2];
        ofVec2f currentPoint = path[path.size() - 1];
        
        ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
        
        //Set vertices
        
        int indiceOffset = vertices.size();
        
        vertices.push_back(lastPoint + normal * lastLineWidth * 0.5);
        vertices.push_back(currentPoint + normal * lineWidth * 0.5);
        vertices.push_back(currentPoint - normal * lineWidth * 0.5);
        vertices.push_back(lastPoint - normal * lastLineWidth * 0.5);
        
        //Set colors
        
        colors.push_back(lastColor);
        colors.push_back(color);
        colors.push_back(color);
        colors.push_back(lastColor);
        
        //Set tex coords
        
        texCoords.push_back(ofVec2f(0, 0));
        texCoords.push_back(ofVec2f(1, 0));
        texCoords.push_back(ofVec2f(1, 1));
        texCoords.push_back(ofVec2f(0, 1));
        
        //Set indices
        
        indices.push_back(indiceOffset);
        indices.push_back(indiceOffset + 1);
        indices.push_back(indiceOffset + 2);
        
        indices.push_back(indiceOffset + 2);
        indices.push_back(indiceOffset + 3);
        indices.push_back(indiceOffset);
        
    }else if(path.size() - offsetLine > 2){ //More than two points --> can recalculate line cap
        
        //Add one point, calculate the mesh and recalculate last segment to make a clean line cap.
        
        ofVec2f lastLastPoint = path[path.size() - 3];
        ofVec2f lastPoint = path[path.size() - 2];
        ofVec2f currentPoint = path[path.size() - 1];
        
        ofVec2f lastNormal = (lastPoint - lastLastPoint).getPerpendicular();
        ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
        
        //Recalculate last line cap.
        
        ofVec2f recalculatedNormal = (lastNormal + normal).normalize();
        
        float amp = lastLineWidth / cos(lastNormal.angleRad(recalculatedNormal));
        
        vertices[vertices.size() - 3] = lastPoint + recalculatedNormal * amp * 0.5;
        vertices[vertices.size() - 2] = lastPoint - recalculatedNormal * amp * 0.5;
        
        //Set vertices
        
        int indiceOffset = vertices.size();
        
        vertices.push_back(lastPoint + recalculatedNormal * amp * 0.5);
        vertices.push_back(currentPoint + normal * lineWidth * 0.5);
        vertices.push_back(currentPoint - normal * lineWidth * 0.5);
        vertices.push_back(lastPoint - recalculatedNormal * amp * 0.5);
        
        //Set colors
        
        colors.push_back(lastColor);
        colors.push_back(color);
        colors.push_back(color);
        colors.push_back(lastColor);
        
        //Set tex coords
        
        texCoords.push_back(ofVec2f(0, 0));
        texCoords.push_back(ofVec2f(1, 0));
        texCoords.push_back(ofVec2f(1, 1));
        texCoords.push_back(ofVec2f(0, 1));
        
        //Set indices
        
        indices.push_back(indiceOffset);
        indices.push_back(indiceOffset + 1);
        indices.push_back(indiceOffset + 2);
        
        indices.push_back(indiceOffset + 2);
        indices.push_back(indiceOffset + 3);
        indices.push_back(indiceOffset);
        
    }
    
}

void VboLine::setColor(float _r, float _g, float _b){
    
    color = ofFloatColor(_r, _g, _b, 1.0);
    
}

void VboLine::setColor(float _r, float _g, float _b, float _a){
    
    color = ofFloatColor(_r, _g, _b, _a);
    
}

void VboLine::setWidth(float _width){
    
    lineWidth = _width;
    
}

void VboLine::setDrawMode(int _drawMode){
    
    drawMode = _drawMode;
    
    vbo.setVertexData(&vertices[0], (int)vertices.size(), drawMode);
    vbo.setIndexData(&indices[0], (int)indices.size(), drawMode);
    vbo.setColorData(&colors[0], (int) colors.size(), drawMode);
    
}

void VboLine::updateLineVertices(int _lineIndex, vector<ofVec2f> _newLine){
    
    
}

void VboLine::updateLineColors(int _lineIndex, vector<ofFloatColor> _newColors){
    
    
    
}

//Get

int VboLine::getLineIndex(){
    
    return linesLength.size();
    
}

vector<ofVec2f> VboLine::getLine(int _lineIndex){
    
    vector<ofVec2f> returnedVertices;
    
    if(_lineIndex > linesLength.size()) return returnedVertices;
    
    int lineOffset = 0;
    
    for(int i = 0; i < _lineIndex; i++){
        
        lineOffset += linesLength[i];
        
    }
    
    returnedVertices.insert(returnedVertices.begin(), path.begin() + lineOffset, path.begin() + lineOffset + linesLength[_lineIndex]);
    
    return returnedVertices;
    
}