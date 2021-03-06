//
//  Polygone.h
//  particleSystem
//
//  Created by Pietro Alberti on 25.12.16.
//
//

#ifndef Polygone_h
#define Polygone_h

#include <stdio.h>
#include "ofxiOS.h"
#include "ofxTriangle.h"

class Polygone {

private:
    
    ofPolyline polygone;
    ofxTriangle triangulatedPoligone;
    ofPolyline line;
    
    //For GPU Rendering
    vector<ofPoint> triangulatedVertices;
    vector<ofPoint> vertices;
    vector<ofIndexType> indices;
    vector<ofVec3f> baricentricCoords;
    
    ofPolyline boundingBoxDebug;
    
    float offsetBoundingBox;
    ofRectangle boundingBox;
    
    ofVec2f getIntersectionTwoLines(ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4);
    bool segmentsAreIntersecting(ofVec2f _intersection, ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4);
    
public:
    
    Polygone();
    
    //Main
    
    void debugDraw();
    void drawWireframe();
    void addVertex(float _x, float y);
    
    //Set
    
    void setOffsetBoundingBox(float _offset);
    
    //Get
    
    void getParticleCollisionsInformations(ofVec2f _currentPos, ofVec2f _direction, float _maxDist, function<void(ofVec2f _intersection, ofVec2f _normalAtIntersection)> _callback);
    
    bool inside(ofVec2f _position);
    bool insideBoundingBox(ofVec2f _position);
    ofVec2f getClosestPoint(ofVec2f _position);
    vector<ofPoint> getVertices();
    vector<ofIndexType> getIndices();
    ofxTriangle getTriangulatedPolygone();
    vector<ofVec3f> getBaricentricCoords();
    ofPolyline getRawPoligone();

    
};

#endif /* Polygone_h */
