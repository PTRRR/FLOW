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
    shader.load("shaders/lineShader");
    
}

VboLine::VboLine(int _drawMode){
    
    drawMode = _drawMode;
    vbo.clear();
    shader.load("shaders/lineShader");
    
}

void VboLine::draw(){
    
    vbo.drawElements(GL_TRIANGLES, (int) indices.size());
    
}

void VboLine::drawShaded(){
    
    shader.begin();
    vbo.drawElements(GL_TRIANGLES, (int) indices.size());
    shader.end();
    
}

void VboLine::debugDraw(){
    
    ofPushStyle();
    
    ofSetColor(0, 255, 0);
    ofNoFill();
    
    if(linesLength.size() > 0){
        
        int offset = 0;
        
        for(int i = 0; i < linesLength.size(); i++){
            
            int currentLength = linesLength[i];
            
            ofBeginShape();
            
            //Begin from the second point of the line to have directly access to two points at a time to
            //draw a segment.
            
            for(int j = 1; j < currentLength; j++){
                
                ofVertex(path[offset + j - 1].x, path[offset + j - 1].y);
                ofVertex(path[offset + j].x, path[offset + j].y);
                
            }
            
            ofEndShape();
            
            offset += currentLength;
            
        }
        
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
    linesLength.push_back(0);
    pathClosed.push_back(false);
    
}

void VboLine::end(){
    
    isDrawing = false;
    currentLineIndex ++;
    
    if(autoBuild){
     
        build();
        setVbo();
        
    }
    
}

void VboLine::addPoint(float _x, float _y){
    
    if(!isDrawing) return;
    
    linesLength[currentLineIndex] ++;
    
    path.push_back(ofVec2f(_x, _y));
    pathRadiuses.push_back(lineWidth);
    pathColors.push_back(color);
    
    lastLineWidth = lineWidth;
    lastColor = color;
    
}

void VboLine::close(){
    
    if(!isDrawing) return;
    
    int offset = 0;
    
    for(int i = 0; i < currentLineIndex; i++){
        offset += linesLength[i];
    }
    
    cout << offset << endl;
    
    addPoint(path[offset].x, path[offset].y);
    
    pathClosed[currentLineIndex] = true;
    
}

void VboLine::build(){
    
    if (isDrawing) return;
    
    vertices.erase(vertices.begin(), vertices.end());
    indices.erase(indices.begin(), indices.end());
    colors.erase(colors.begin(), colors.end());
    texCoords.erase(texCoords.begin(), texCoords.end());
    
    int offset = 0;
    
    for(int i = 0; i < linesLength.size(); i++){
        
        for(int j = offset; j < offset + linesLength[i]; j++){
            
            if(j - offset == 1){ //Two points
                
                //Add one point and calculate mesh according to the normal
                //of the first segment and the current line width.
                //We have to know the position of the last point to get the normal.
                //The normal is the perpendicular vector to the vector pointing from the point just added
                //toward the last point.
                
                ofVec2f lastPoint = path[j - 1];
                ofVec2f currentPoint = path[j];
                
                ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
                
                //Set vertices
                
                int indiceOffset = vertices.size();
                
                vertices.push_back(lastPoint + normal * pathRadiuses[j - 1] * 0.5);
                vertices.push_back(currentPoint + normal * pathRadiuses[j] * 0.5);
                vertices.push_back(currentPoint - normal * pathRadiuses[j] * 0.5);
                vertices.push_back(lastPoint - normal * pathRadiuses[j - 1] * 0.5);
                
                //Set colors
                
                colors.push_back(pathColors[j - 1]);
                colors.push_back(pathColors[j]);
                colors.push_back(pathColors[j]);
                colors.push_back(pathColors[j - 1]);
                
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
                
            }else if(j - offset > 1){ //More than two points --> can recalculate line cap
                
                //Add one point, calculate the mesh and recalculate last segment to make a clean line cap.
                
                ofVec2f lastLastPoint = path[j - 2];
                ofVec2f lastPoint = path[j - 1];
                ofVec2f currentPoint = path[j];
                
                ofVec2f lastNormal = (lastPoint - lastLastPoint).getPerpendicular();
                ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
                
                //Recalculate last line cap.
                
                ofVec2f recalculatedNormal = (lastNormal + normal).normalize();
                
                float amp = pathRadiuses[j - 1] / cos(lastNormal.angleRad(recalculatedNormal));
                
                vertices[vertices.size() - 3] = lastPoint + recalculatedNormal * amp * 0.5;
                vertices[vertices.size() - 2] = lastPoint - recalculatedNormal * amp * 0.5;
                
                //Set vertices
                
                int indiceOffset = vertices.size();
                
                vertices.push_back(lastPoint + recalculatedNormal * amp * 0.5);
                vertices.push_back(currentPoint + normal * pathRadiuses[j] * 0.5);
                vertices.push_back(currentPoint - normal * pathRadiuses[j] * 0.5);
                vertices.push_back(lastPoint - recalculatedNormal * amp * 0.5);
                
                //Set colors
                
                colors.push_back(pathColors[j - 1]);
                colors.push_back(pathColors[j]);
                colors.push_back(pathColors[j]);
                colors.push_back(pathColors[j - 1]);
                
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
        
        if (pathClosed[i]) {
            
            ofVec2f lastLastPoint = path[offset + linesLength[i] - 2];
            ofVec2f lastPoint = path[offset];
            ofVec2f currentPoint = path[offset + 1];
            
            ofVec2f lastNormal = (lastPoint - lastLastPoint).getPerpendicular();
            ofVec2f normal = (currentPoint - lastPoint).getPerpendicular();
            
            //Recalculate last line cap.
            
            ofVec2f recalculatedNormal = (lastNormal + normal).normalize();
            
            float amp = lastLineWidth / cos(lastNormal.angleRad(recalculatedNormal));
            
            vertices[vertices.size() - 3] = lastPoint + recalculatedNormal * amp * 0.5;
            vertices[vertices.size() - 2] = lastPoint - recalculatedNormal * amp * 0.5;
            
            vertices[offsetVertices] = lastPoint + recalculatedNormal * amp * 0.5;
            vertices[offsetVertices + 3] = lastPoint - recalculatedNormal * amp * 0.5;
            
        }
        
        offset += linesLength[i];
        
    }

}

void VboLine::clear(){
    
    if(isDrawing) return;
    
    vbo.clear();
    linesLength.erase(linesLength.begin(), linesLength.end());
    path.erase(path.begin(), path.end());
    pathClosed.erase(pathClosed.begin(), pathClosed.end());
    pathRadiuses.erase(pathRadiuses.begin(), pathRadiuses.end());
    pathColors.erase(pathColors.begin(), pathColors.end());
    vertices.erase(vertices.begin(), vertices.end());
    indices.erase(indices.begin(), indices.end());
    colors.erase(colors.begin(), colors.end());
    texCoords.erase(texCoords.begin(), texCoords.end());
    
}

void VboLine::setVbo(){
    
    vbo.setVertexData(&vertices[0], (int)vertices.size(), drawMode);
    vbo.setIndexData(&indices[0], (int) indices.size(), drawMode);
    vbo.setColorData(&colors[0], (int) colors.size(), drawMode);
    vbo.setTexCoordData(&texCoords[0], (int) texCoords.size(), drawMode);
    
}

void VboLine::updateVbo(){
    
    vbo.updateVertexData(&vertices[0], (int)vertices.size());
    vbo.updateColorData(&colors[0], (int) colors.size());
    
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

void VboLine::updateLine(int _lineIndex, vector<ofVec2f> _newLine){
    
    if(_lineIndex > linesLength.size() - 1) return;
    
    int offset = 0;
    
    for(int i = 0; i < _lineIndex; i++){
        offset += linesLength[i];
    }
    
    for(int i = 0; i < _newLine.size(); i++){
        
        path[offset + i] = _newLine[i];
        
    }
    
    if(autoBuild){
        
        build();
        updateVbo();
        
    }
    
}

void VboLine::updateLineColors(int _lineIndex, vector<ofFloatColor> _newColors){
    
    if(_lineIndex > linesLength.size() - 1) return;
    
    int offset = 0;
    
    for(int i = 0; i < _lineIndex; i++){
        offset += linesLength[i];
    }
    
    for(int i = 0; i < _newColors.size(); i++){
        
        pathColors[offset + i] = _newColors[i];
        
    }
    
    if(autoBuild){
        
        build();
        updateVbo();
        
    }
    
}

void VboLine::setAutoBuild(bool _autoBuild){
    
    autoBuild = _autoBuild;
    
}

//Get

int VboLine::getLineIndex(){
    
    return currentLineIndex;
    
}

vector<ofVec2f> VboLine::getLine(int _lineIndex){
    
    vector<ofVec2f> returnedVertices;
    
    if(_lineIndex > linesLength.size()) return returnedVertices;
    
    int offset = 0;
    
    for(int i = 0; i < _lineIndex; i++){
        
        offset += linesLength[i];
        
    }
    
    returnedVertices.insert(returnedVertices.begin(), path.begin() + offset, path.begin() + offset + linesLength[_lineIndex]);
    
    return returnedVertices;
    
}

vector<ofFloatColor> VboLine::getLineColors(int _lineIndex){
    
    vector<ofFloatColor> returnedColors;
    
    if(_lineIndex > pathColors.size()) return returnedColors;
    
    int offset = 0;
    
    for(int i = 0; i < _lineIndex; i++){
        
        offset += linesLength[i];
        
    }
    
    returnedColors.insert(returnedColors.begin(), pathColors.begin() + offset, pathColors.begin() + offset + linesLength[_lineIndex]);
    
    return returnedColors;
    
}

int VboLine::getLineNum(){
    
    return linesLength.size();
    
}