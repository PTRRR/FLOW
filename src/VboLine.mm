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
    
}

VboLine::VboLine(int _drawMode){
    
    drawMode = _drawMode;
    
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
    offsetLine = path.size();
    
}

void VboLine::addPoint(float _x, float _y){
    
    if(!isDrawing) return;
    
    float lineWidth = 10.0;
    
    if(path.size() - offsetLine == 0){
        
        path.push_back(ofVec2f(_x, _y));
        
    }else if(path.size() - offsetLine > 0){
        
        path.push_back(ofVec2f(_x, _y));
        
        ofVec2f lastPoint = path[path.size() - 2];
        ofVec2f currentPoint = path[path.size() - 1];
        
        ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
        
        cout << lastPoint << " / " << currentPoint << endl;
        
        //Set vertices
        
        int indiceOffset = vertices.size();
        
        vertices.push_back(lastPoint + normal * lineWidth);
        vertices.push_back(currentPoint + normal * lineWidth);
        vertices.push_back(currentPoint - normal * lineWidth);
        vertices.push_back(lastPoint - normal * lineWidth);
        
        //Set colors
        
        colors.push_back(ofFloatColor(1.0, 0.0, 0.0, 1.0));
        colors.push_back(ofFloatColor(0.0, 1.0, 0.0, 1.0));
        colors.push_back(ofFloatColor(0.0, 0.0, 1.0, 1.0));
        colors.push_back(ofFloatColor(1.0, 1.0, 0.0, 1.0));
        
        //Set tex coords
        
        texCoords.push_back(ofVec2f(0, 0));
        texCoords.push_back(ofVec2f(1, 0));
        texCoords.push_back(ofVec2f(1, -1));
        texCoords.push_back(ofVec2f(0, -1));
        
        //Set indices
        
        indices.push_back(indiceOffset);
        indices.push_back(indiceOffset + 1);
        indices.push_back(indiceOffset + 2);
        
        indices.push_back(indiceOffset + 2);
        indices.push_back(indiceOffset + 3);
        indices.push_back(indiceOffset);
        
    }
    
    vbo.setVertexData(&vertices[0], (int)vertices.size(), drawMode);
    vbo.setIndexData(&indices[0], (int) indices.size(), drawMode);
    vbo.setColorData(&colors[0], (int) colors.size(), drawMode);
    vbo.setTexCoordData(&texCoords[0], (int) texCoords.size(), drawMode);
    
}

void VboLine::setDrawMode(int _drawMode){
    
    drawMode = _drawMode;
    
    vbo.setVertexData(&vertices[0], (int)vertices.size(), drawMode);
    vbo.setIndexData(&indices[0], (int)indices.size(), drawMode);
    vbo.setColorData(&colors[0], (int) colors.size(), drawMode);
    
}