//
//  LevelCreator.cpp
//  FLOW
//
//  Created by Pietro Alberti on 10.01.17.
//
//

#include "LevelCreator.h"

LevelCreator::LevelCreator(){}

LevelCreator::LevelCreator(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(font);
    
    interface.addButton("MENU", "MENU", ofVec2f(ofGetWidth() - 100, 40));
    interface.addButton("PRINT", "PRINT", ofVec2f(ofGetWidth() - 400, 40));
    interface.addButton("V", "V", ofVec2f(ofGetWidth() - 600, 40));
    interface.addButton("E", "E", ofVec2f(ofGetWidth() - 800, 40));
    interface.addButton("R", "R", ofVec2f(ofGetWidth() - 1000, 40));
    interface.addButton("LOAD", "LOAD", ofVec2f(ofGetWidth() - 1200, 40));
    
    rows = (ofGetHeight() / 512) * 10;
    columns = (ofGetWidth() / 512) * 10;
    
    cout << ofGetWidth() << endl << ofGetHeight() << endl;
    cout <<  PGCD((long) ofGetWidth(), (long) ofGetWidth()) << endl;
    
    
    //Set points
    
    for(int i = 1; i < rows; i++){
        
        for(int j = 1; j < columns; j++){
            
            points.push_back(ofVec2f( ofGetWidth() / columns * j, ofGetHeight() / rows * i ));
            
        }
        
    }
    
}

void LevelCreator::renderToScreen(){
    
    ofSetColor(255, 255, 255, getAlpha());
    
    ofPushStyle();

    //Draw grid
    
    ofSetColor(100, 100, 100, getAlpha());
    
    //Rows
    
    for(int i = 0; i < rows; i++){

        ofDrawLine(0, ofGetHeight() / rows * i, ofGetWidth(), ofGetHeight() / rows * i);
        
    }
    
    //Columns
    
    for(int i = 0; i < columns; i++){
        
        ofDrawLine(ofGetWidth() / columns * i, 0, ofGetWidth() / columns * i, ofGetHeight());
        
    }
    
    //Draw points
    
    for(int i = 0; i < points.size(); i++){
        
        ofDrawCircle(points[i], 3);
        
    }
    
    //Draw polygones
    
    
    ofNoFill();
    ofSetColor(255, 255, 255, getAlpha());
    
    for(int i = 0; i < polylines.size(); i++){
        
        ofBeginShape();
        
        for(int j = 0; j < polylines[i].getVertices().size(); j++){
            
            ofVertex(polylines[i].getVertices()[j].x, polylines[i].getVertices()[j].y);
            ofDrawCircle(polylines[i].getVertices()[j] , 6);
            
            if(j == polylines[i].getVertices().size() - 1){
                
                ofVertex(polylines[i].getVertices()[0].x, polylines[i].getVertices()[0].y);
                
            }
            
        }
        
        ofEndShape();
        
    }
    
    //Draw emitters
    
    ofSetColor(255, 0, 0);
    
    for(int i = 0; i < emitters.size(); i++){
        
        ofDrawCircle(emitters[i], 40);
        ofDrawBitmapString("emitter " + to_string(i), emitters[i]);
        
    }
    
    ofSetColor(0, 255, 0);
    
    for(int i = 0; i < receptors.size(); i++){
        
        ofDrawCircle(receptors[i], 40);
        ofDrawBitmapString("receptors " + to_string(i), receptors[i]);
        
    }
    
    if(down){
        
        ofDrawLine(touch.x, touch.y - 100, touch.x, touch.y + 100);
        ofDrawLine(touch.x - 100, touch.y, touch.x + 100, touch.y);
        ofDrawCircle(touch, 70);
        
    }
    
    ofPopStyle();
    
   
    
    ofDrawBitmapString(content, 20, 20);
    
    interface.draw();
    
}

void LevelCreator::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    interface.setFont(_font);
    
}

ofVec2f LevelCreator::getClosestPoint(ofVec2f _position){
    
    //Find the closest point in the grid.
    
    float maxDistWidth = (ofGetWidth() / columns) / 2;
    float maxDistHeight = (ofGetHeight() / rows) / 2;
    
    for(int i = 0; i < points.size(); i++){
        
        float distWidth = (_position - points[i]).x;
        float distHeight = (_position - points[i]).y;
        
        if(distWidth < maxDistWidth && distHeight < maxDistHeight){
            
            return points[i];
            break;
            
        }
        
    }
    
    return ofVec2f(0);
    
}

long LevelCreator::PGCD(long a, long b){
    
    long r;
    
    r=a%b;
    
    while(r)
    {
        a=b;
        b=r;
        r=a%b;
    }
    return b;
}

void LevelCreator::printLevel(){
    
    ofxXmlSettings xml;
    
    //Emitters
    
    xml.addTag("emitters");
    xml.pushTag("emitters");
    
    for(int i = 0; i < emitters.size(); i++){
        
        xml.addTag("emitter");
        xml.pushTag("emitter", i);
        
        xml.addValue("X", emitters[i].x / ofGetWidth());
        xml.addValue("Y", emitters[i].y / ofGetHeight());
        xml.addValue("boxX", 0.006510417);
        xml.addValue("boxY", 0.000488281);
        xml.addValue("rate", 90.000000000);
        xml.addValue("maxParticles", 1000);
        xml.addValue("maxTailLength", 25);
        
        xml.popTag();
        
    }
    
    xml.popTag();
    
    //Receptors
    
    xml.addTag("receptors");
    xml.pushTag("receptors");
    
    for(int i = 0; i < receptors.size(); i++){
        
        xml.addTag("receptor");
        xml.pushTag("receptor", i);
        
        xml.addValue("X", receptors[i].x / ofGetWidth());
        xml.addValue("Y", receptors[i].y / ofGetHeight());
        xml.addValue("radius", 0.130208328);
        xml.addValue("strength", 5.000000000);
        xml.addValue("maxParticles", 300);
        xml.addValue("decreasingFactor", 0.022000000);
        
        xml.popTag();
        
    }
    
    xml.popTag();
    
    //Polygones
    
    xml.addTag("polygones");
    xml.pushTag("polygones");
    
    for(int i = 0; i < polylines.size(); i++){
        
        //Polygone container
        xml.addTag("polygone");
        xml.pushTag("polygone", i);
        
        xml.addTag("vertices");
        xml.pushTag("vertices");
        
        for(int j = 0; j < polylines[i].getVertices().size(); j++){
            
            xml.addTag("vertex");
            xml.pushTag("vertex", j);
            
            xml.addValue("X", polylines[i].getVertices()[j].x / ofGetWidth());
            xml.addValue("Y", polylines[i].getVertices()[j].y / ofGetHeight());
            xml.addValue("Z", polylines[i].getVertices()[j].z);
            
            xml.popTag();
            
        }
        
        xml.popTag(); //vertice
        xml.popTag(); //vertices
    }
    
    xml.popTag();
    
    
    xml.copyXmlToString(content);
    
    cout << content << endl;
    
}

void LevelCreator::setup(string _xmlFile){
    
    if(_xmlFile != ""){
    
        loadXML(_xmlFile, [&](ofxXmlSettings _XML){
        
            _XML.pushTag("emitters");
            
            int numEmitters = _XML.getNumTags("emitter");
            
            for(int i = 0; i < numEmitters; i++){
                
                _XML.pushTag("emitter", i);
                
                ofVec2f position = ofVec2f(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
                
                emitters.push_back(position);
                
                _XML.popTag();
                
            }
            
            _XML.popTag();
            
            //Receptors
            
            _XML.pushTag("receptors");
            
            int numReceptors = _XML.getNumTags("receptor");
            
            for(int i = 0; i < numReceptors; i++){
                
                _XML.pushTag("receptor", i);
                
                ofVec2f position = ofVec2f(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
                
                receptors.push_back(position);
                
                _XML.popTag();
                
            }
            
            _XML.popTag();
            
            //Polygones
            
            _XML.pushTag("polygones");
            
            int numPolygones = _XML.getNumTags("polygone");
            
            for(int i = 0; i < numPolygones; i++){
                
                _XML.pushTag("polygone", i);
                
                polylines.push_back(ofPolyline());
                
                _XML.pushTag("vertices");
                
                int numVertices = _XML.getNumTags("vertex");
                
                for(int j = 0; j < numVertices; j++){
                    
                    _XML.pushTag("vertex", j);
                    
                    polylines[polylines.size() - 1].addVertex(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
                    
                    _XML.popTag();
                    
                }
                
                _XML.popTag();
                
                _XML.popTag();
                
            }
            
            _XML.popTag();
            
        });
        
    }
    
}

//Inputs

void LevelCreator::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    touch = getClosestPoint(_touch);
    
    bool button = false;
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
        button = true;
    });
    
    if(button) return;
    
    if(v && !db){
        
        if(noPolyline){
            
            polylines.push_back(ofPolyline());
            
            ofVec2f closestPoint = getClosestPoint(_touch);
            polylines[polylines.size() - 1].addVertex(closestPoint.x, closestPoint.y);
            polylines[polylines.size() - 1].close();
            
            noPolyline = false;
            
        }else{
            
            ofVec2f closestPoint = getClosestPoint(_touch);
            ofVec2f lastPoint = polylines[polylines.size() - 1].getVertices()[polylines[polylines.size() - 1].getVertices().size() - 1];
            
            if (polylines[polylines.size() - 1].getVertices().size() > 1 && closestPoint.x == polylines[polylines.size() - 1].getVertices()[0].x && closestPoint.y == polylines[polylines.size() - 1].getVertices()[0].y) {
                
                noPolyline = true;
                
            }else if(closestPoint.x == lastPoint.x && closestPoint.y == lastPoint.y){
                
                vector<ofPoint> vertices = polylines[polylines.size() - 1].getVertices();
                vertices.erase(vertices.begin() + vertices.size() - 1);
                
                polylines[polylines.size() - 1].clear();
                polylines[polylines.size() - 1].addVertices(vertices);
                cout << "remove" << endl;
                
            }else if(polylines[polylines.size() - 1].getVertices().size() == 1 && closestPoint.x == lastPoint.x && closestPoint.y == lastPoint.y){
                
                polylines[polylines.size() - 1].clear();
                polylines.erase(polylines.begin() + polylines.size() - 1);
                
            }else{
                
                polylines[polylines.size() - 1].addVertex(closestPoint.x, closestPoint.y);
                polylines[polylines.size() - 1].close();
                
            }
            
        }
        
    }else if(e){
        
        ofVec2f closestPoint = getClosestPoint(_touch);
        
        bool removed = false;
        
        for(int i = 0; i < emitters.size(); i++){
            
            if(closestPoint.x == emitters[i].x && closestPoint.y == emitters[i].y){
                emitters.erase(emitters.begin() + emitters.size() - 1);
                removed = true;
                break;
            }
            
        }
        
        if(!removed) emitters.push_back(closestPoint);
        
    }else if(r){
        
        ofVec2f closestPoint = getClosestPoint(_touch);
        
        bool removed = false;
        
        for(int i = 0; i < receptors.size(); i++){
            
            if(closestPoint.x == receptors[i].x && closestPoint.y == receptors[i].y){
                receptors.erase(receptors.begin() + receptors.size() - 1);
                removed = true;
                break;
            }
            
        }
        
        if(!removed) receptors.push_back(closestPoint);
        
    }
    
    if(db){
     
        polylines.erase(polylines.begin() + polylines.size() - 1);
        db = false;
        
    }
    
    down = true;

}

void LevelCreator::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    touch = getClosestPoint(_touch);
    
    if(polylines.size() > 0){
     
        vector<ofPoint> vertices = polylines[polylines.size() - 1].getVertices();
        vertices.erase(vertices.begin() + vertices.size() - 1);
        vertices.push_back(getClosestPoint(_touch));
        
        polylines[polylines.size() - 1].clear();
        polylines[polylines.size() - 1].addVertices(vertices);
        
        interface.mouseMove(_touch, [&](string text, string action){
            callback(text, action);
        });
        
    }
    
}

void LevelCreator::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseUp(_touch, [&](string text, string action){
        
        if(action == "PRINT"){
            printLevel();
        }else if(action == "R"){
            
            r = true;
            v = false;
            e = false;
            
        }else if(action == "E"){
            
            r = false;
            v = false;
            e = true;
            
        }else if(action == "V"){
            
            r = false;
            v = true;
            e = false;
            
        }else if(action == "MENU"){
            polylines.erase(polylines.begin(), polylines.end());
            emitters.erase(emitters.begin(), emitters.end());
            receptors.erase(receptors.begin(), receptors.end());
        }
        
        callback(text, action);
        
    });
    
    down = false;
    
}

void LevelCreator::onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    if(polylines[polylines.size() - 1].getVertices().size() == 1){
     
        for(int i = 0; i < polylines.size(); i++){
            
            if(polylines[i].inside(_touch)){
                
                polylines.erase(polylines.begin() + i);
                break;
                
            }
            
        }
        
        db = true;
        noPolyline = true;
        
    }
    
}