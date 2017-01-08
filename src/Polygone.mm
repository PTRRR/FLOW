//
//  Polygone.mm
//  particleSystem
//
//  Created by Pietro Alberti on 25.12.16.
//
//

#include "Polygone.h"

Polygone::Polygone(){

    offsetBoundingBox = 40;

}

void Polygone::debugDraw(){

    ofPushStyle();
    
    polygone.draw();
    
    ofSetColor(255, 0, 255);
//    boundingBoxDebug.draw();
    
    for(int i = 0; i < triangulatedPoligone.nTriangles; i++){
        ofBeginShape();
        
        ofSetColor(ofRandom(255), ofRandom(255), ofRandom(255));
        
        ofVertex(triangulatedPoligone.triangles[i].a.x, triangulatedPoligone.triangles[i].a.y);
        ofVertex(triangulatedPoligone.triangles[i].b.x, triangulatedPoligone.triangles[i].b.y);
        ofVertex(triangulatedPoligone.triangles[i].c.x, triangulatedPoligone.triangles[i].c.y);
        
        ofEndShape();
    }
    
    for(int i = 0; i < indices.size(); i++){
        
        ofDrawCircle(vertices[indices[i]].x, vertices[indices[i]].y, 10);
        
    }
    
    ofPopStyle();
    
}

void Polygone::drawWireframe(){
    
    ofSetColor(255, 255, 255);
    
    for(int i = 0; i < triangulatedPoligone.nTriangles; i++){
        
        float aX = triangulatedPoligone.triangles[i].a.x;
        float aY = triangulatedPoligone.triangles[i].a.y;
        
        float bX = triangulatedPoligone.triangles[i].b.x;
        float bY = triangulatedPoligone.triangles[i].b.y;
        
        float cX = triangulatedPoligone.triangles[i].c.x;
        float cY = triangulatedPoligone.triangles[i].c.y;
        
        ofDrawLine(aX, aY, bX, bY);
        ofDrawLine(bX, bY, cX, cY);
        ofDrawLine(cX, cY, aX, aY);
        
    }
    
    
    
}

void Polygone::addVertex(float _x, float _y){
    
    vertices.push_back(ofPoint(_x, _y));
    polygone.addVertex(_x, _y);
    
    if(vertices.size() >= 3){
     
        triangulatedPoligone.clear();
        triangulatedPoligone.triangulate(polygone.getVertices());
        
        //Update indices
        
        indices.erase(indices.begin(), indices.end());
            
        for(int j = 0; j < triangulatedPoligone.nTriangles; j++){
            
            ofPoint a = ofPoint(triangulatedPoligone.triangles[j].a.x, triangulatedPoligone.triangles[j].a.y);
            ofPoint b = ofPoint(triangulatedPoligone.triangles[j].b.x, triangulatedPoligone.triangles[j].b.y);
            ofPoint c = ofPoint(triangulatedPoligone.triangles[j].c.x, triangulatedPoligone.triangles[j].c.y);
            
            baricentricCoords.push_back(ofVec3f(1, 0, 0));
            baricentricCoords.push_back(ofVec3f(0, 0, 1));
            baricentricCoords.push_back(ofVec3f(0, 1, 0));
            
            for(int i = 0; i < vertices.size(); i++){
                
                if(a == vertices[i]){
                    indices.push_back(i);
                    
                }
                if(b == vertices[i]){
                    indices.push_back(i);
                    
                }
                if(c == vertices[i]){
                    indices.push_back(i);
                    
                }
                
            }
            
        }
        
    }
    
    polygone.close();
    
    boundingBox = polygone.getBoundingBox();
    boundingBox.x -= offsetBoundingBox;
    boundingBox.width += 2 * offsetBoundingBox;
    boundingBox.y -= offsetBoundingBox;
    boundingBox.height += 2 * offsetBoundingBox;
    
    boundingBoxDebug.clear();
    boundingBoxDebug.addVertex(boundingBox.x, boundingBox.y);
    boundingBoxDebug.addVertex(boundingBox.x + boundingBox.width, boundingBox.y);
    boundingBoxDebug.addVertex(boundingBox.x + boundingBox.width, boundingBox.y + boundingBox.height);
    boundingBoxDebug.addVertex(boundingBox.x, boundingBox.y + boundingBox.height);
    boundingBoxDebug.close();
    
}

//Set

void Polygone::setOffsetBoundingBox(float _offset){
    
    offsetBoundingBox = _offset;
    
}

//Get

void Polygone::getParticleCollisionsInformations(ofVec2f _currentPos, ofVec2f _direction, float _maxDist, function<void(ofVec2f _intersection, ofVec2f _normalAtIntersection)> _callback){
    
    vector<ofVec2f> intersections;
    vector<ofVec2f> normals;
    
    for(int i = 0; i < polygone.getVertices().size(); i++){
        
        ofVec2f currentVertice = polygone.getVertices()[i];
        ofVec2f nextVertice = i < polygone.getVertices().size() - 1 ? polygone.getVertices()[i + 1] : polygone.getVertices()[0];
        
        //Get the intersection between the two lines
        
        ofVec2f intersection = getIntersectionTwoLines(_currentPos, _currentPos + _direction, currentVertice, nextVertice);
        
        //Check if the two segments are intersecting
        
        if(segmentsAreIntersecting(intersection, _currentPos, _currentPos + _direction.normalize() * _maxDist, currentVertice, nextVertice)){
            
            intersections.push_back(intersection);
            normals.push_back((currentVertice - nextVertice).getPerpendicular().normalize());
//            _callback(intersection, (currentVertice - nextVertice).getPerpendicular().normalize());
            
        }
    }
    
    //If there is more than one intersection get the one nearest to the previous point
    
    if(intersections.size() > 0){
     
        int nearestIndex = 0;
        float minDist = (_currentPos - intersections[0]).length();
        
        for(int i = 0; i < intersections.size(); i++){
            
            float currentDist = (_currentPos - intersections[i]).length();
            if(currentDist < minDist) nearestIndex = i;
            
        }
    
        _callback(intersections[nearestIndex], normals[nearestIndex]);
        
    }
    
}

bool Polygone::inside(ofVec2f _position){
    
    return polygone.inside(_position);
    
}

bool Polygone::insideBoundingBox(ofVec2f _position){
    
    return boundingBox.inside(_position);
    
}

ofVec2f Polygone::getClosestPoint(ofVec2f _position){
    
    return polygone.getClosestPoint(_position);
    
}


vector<ofPoint> Polygone::getVertices(){
    
    return polygone.getVertices();
    
}

vector<ofIndexType> Polygone::getIndices(){
    
    return indices;
    
}

ofxTriangle Polygone::getTriangulatedPolygone(){
    
    return triangulatedPoligone;
    
}

vector<ofVec3f> Polygone::getBaricentricCoords(){
    
    return baricentricCoords;
    
}

//Private

ofVec2f Polygone::getIntersectionTwoLines(ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4){
    
    ofVec2f intersection = ofVec2f(0);
    
    //Calculate the determinant
    
    intersection.x = ((_p1.x * _p2.y - _p1.y * _p2.x) * (_p3.x - _p4.x) - (_p1.x - _p2.x) * (_p3.x * _p4.y - _p3.y * _p4.x)) / ((_p1.x - _p2.x) * (_p3.y - _p4.y) - (_p1.y - _p2.y) * (_p3.x - _p4.x));
    
    intersection.y = ((_p1.x * _p2.y - _p1.y * _p2.x) * (_p3.y - _p4.y) - (_p1.y - _p2.y) * (_p3.x * _p4.y - _p3.y * _p4.x)) / ((_p1.x - _p2.x) * (_p3.y - _p4.y) - (_p1.y - _p2.y) * (_p3.x - _p4.x));
    
    return intersection;
    
}

bool Polygone::segmentsAreIntersecting(ofVec2f _intersection, ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4){
    
    float distance1 = (_p1 - _p2).length() + 0.0001; //Add a minimum value to compensate floating error
    float distance2 = (_p3 - _p4).length() + 0.0001; //Add a minimum value to compensate floating error
    
    if(((_p1 - _intersection).length() + (_p2 - _intersection).length()) <= distance1 && ((_p3 - _intersection).length() + (_p4 - _intersection).length()) <= distance2){ //Check if less or equal to compensate floating error
        return true;
    }
    
    return false;
    
}