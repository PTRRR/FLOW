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
    interface.addButton("V", "V", ofVec2f(ofGetWidth() - 600, 40))->setHighlight(true);
    interface.addButton("E", "E", ofVec2f(ofGetWidth() - 800, 40));
    interface.addButton("R", "R", ofVec2f(ofGetWidth() - 1000, 40));
    interface.addButton("LOAD", "LOAD", ofVec2f(ofGetWidth() - 1200, 40));
    interface.addButton("SAVE", "SAVE", ofVec2f(ofGetWidth() - 1400, 40));
    
    rows = (int) ofGetHeight() / (512 * 0.07);
    columns = (int) ofGetWidth() / (512 * 0.07);
    
    //Set grid
    
    for(int i = 1; i < rows; i++)
    {
        for(int j = 1; j < columns; j++)
        {
            points.push_back(ofVec2f( (float) ofGetWidth() / columns * j, (float) ofGetHeight() / rows * i ));
        }
    }
    
    for(int i = 0; i < rows; i++){
        
        gridVertices.push_back(ofVec3f(0, (float) ofGetHeight() / rows * i, 0));
        gridVertices.push_back(ofVec3f(ofGetWidth(), (float) ofGetHeight() / rows * i, 0));
        
    }
    
    for(int i = 0; i < columns; i++){
        
        gridVertices.push_back(ofVec3f((float) ofGetWidth() / columns * i, 0, 0));
        gridVertices.push_back(ofVec3f((float) ofGetWidth() / columns * i, ofGetHeight(), 0));
        
    }
    
    gridVbo.setVertexData(&gridVertices[0], (int) gridVertices.size(), GL_STATIC_DRAW);
    
}

void LevelCreator::renderToScreen(){
    
    ofPushStyle();

    //Draw grid
    
    ofSetColor(50, 50, 50, getAlpha());
    
    gridVbo.draw(GL_LINES, 0, (int) gridVertices.size());
    
    //Draw polygones
    
    ofNoFill();
    ofSetColor(255, 255, 255);
    
    for(int i = 0; i < polygones.size(); i++)
    {
        vector<ofPoint> currentVertices = polygones[i].getVertices();
        
        ofBeginShape();
        
        for(int j = 0; j < currentVertices.size(); j++)
        {
            ofVertex(currentVertices[j]);
            ofDrawCircle(currentVertices[j], 5);
            
            if(i == polygones.size() - 1 && j == currentVertices.size() - 1 && currentTouch != nullptr && isDrawing && !isErasing && v)
            {
                ofVertex(currentTouch->x, currentTouch->y);
            }
            
        }
        
        ofEndShape();
        
    }
    
    //Draw emitters
    
    ofSetColor(0, 255, 0);
    
    for(int i = 0; i < emitters.size(); i++)
    {
        ofDrawCircle(emitters[i], 60);
        ofDrawLine(emitters[i].x - 30, emitters[i].y, emitters[i].x + 30, emitters[i].y);
        ofDrawLine(emitters[i].x, emitters[i].y - 30, emitters[i].x, emitters[i].y + 30);
        ofDrawBitmapString("emitter " + to_string(i), emitters[i].x + 70, emitters[i].y);
    }
    
    ofSetColor(255, 0, 0);
    
    for(int i = 0; i < receptors.size(); i++)
    {
        ofDrawCircle(receptors[i], 60);
        ofDrawLine(receptors[i].x - 30, receptors[i].y, receptors[i].x + 30, receptors[i].y);
        ofDrawLine(receptors[i].x, receptors[i].y - 30, receptors[i].x, receptors[i].y + 30);
        ofDrawBitmapString("receptor " + to_string(i), receptors[i].x + 70, receptors[i].y);
    }
    
    ofPopStyle();
    
    ofSetColor(255, 255, 255);
    
    interface.draw();
    
    //Draw taget
    
    ofPushStyle();
    
    if(isErasing)
    {
        ofSetColor(255, 0, 255);
    }
    else{
        ofSetColor(255, 255, 0);
    }
    
    ofNoFill();
    
    if(currentTouch != nullptr)
    {
        ofDrawCircle(currentTouch->x, currentTouch->y, 70);
        ofDrawLine(currentTouch->x - 100, currentTouch->y, currentTouch->x + 100, currentTouch->y);
        ofDrawLine(currentTouch->x, currentTouch->y - 100, currentTouch->x, currentTouch->y + 100);
    }
    
    ofPopStyle();
    
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

void LevelCreator::save(){
    
    ofxXmlSettings xml;
    
    xml.setValue("general:UNLOCKED", 1);
    xml.setValue("general:ORIGINAL_WIDTH", 1536);
    xml.setValue("general:ORIGINAL_HEIGHT", 2048);
    xml.setValue("general:MAX_PARTICLES", 1000);
    xml.setValue("general:MAX_TAIL_LENGTH", 25);
    xml.setValue("general:MAX_ACTUATORS_NUM", 4);
    
    xml.setValue("actuators:MAX_ACTUATORS_NUM", 4);
    xml.setValue("fixedActuators", "");
    
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
        xml.addValue("maxParticles", (float) (1000 / emitters.size()));
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
    
    for(int i = 0; i < polygones.size(); i++){
        
        //Polygone container
        xml.addTag("polygone");
        xml.pushTag("polygone", i);
        
        xml.addTag("vertices");
        xml.pushTag("vertices");
        
        for(int j = 0; j < polygones[i].getVertices().size(); j++){
            
            xml.addTag("vertex");
            xml.pushTag("vertex", j);
            
            xml.addValue("X", polygones[i].getVertices()[j].x / ofGetWidth());
            xml.addValue("Y", polygones[i].getVertices()[j].y / ofGetHeight());
            xml.addValue("Z", polygones[i].getVertices()[j].z);
            
            xml.popTag();
            
        }
        
        xml.popTag(); //vertice
        xml.popTag(); //vertices
    }
    
    xml.popTag();
    
    
    xml.saveFile(currentXML);
    xml.saveFile(ofxiOSGetDocumentsDirectory() + currentXML);
    
    interface.addText("SAVED " + currentXML, ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2));
    
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
        xml.addValue("rate", (float) 90.000000000 / emitters.size());
        xml.addValue("maxParticles", (float) (1000 / emitters.size()));
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
    
    for(int i = 0; i < polygones.size(); i++){
        
        //Polygone container
        xml.addTag("polygone");
        xml.pushTag("polygone", i);
        
        xml.addTag("vertices");
        xml.pushTag("vertices");
        
        for(int j = 0; j < polygones[i].getVertices().size(); j++){
            
            xml.addTag("vertex");
            xml.pushTag("vertex", j);
            
            xml.addValue("X", polygones[i].getVertices()[j].x / ofGetWidth());
            xml.addValue("Y", polygones[i].getVertices()[j].y / ofGetHeight());
            xml.addValue("Z", polygones[i].getVertices()[j].z);
            
            xml.popTag();
            
        }
        
        xml.popTag(); //vertice
        xml.popTag(); //vertices
    }
    
    xml.popTag();
    
    
    xml.copyXmlToString(content);
    
}

void LevelCreator::setup(string _xmlFile){
    
    currentXML = _xmlFile;
    
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
                
                polygones.push_back(ofPolyline());
                
                _XML.pushTag("vertices");
                
                int numVertices = _XML.getNumTags("vertex");
                
                for(int j = 0; j < numVertices; j++){
                    
                    _XML.pushTag("vertex", j);
                    
                    polygones[polygones.size() - 1].addVertex(_XML.getValue("X", 0.0) * ofGetWidth(), _XML.getValue("Y", 0.0) * ofGetHeight());
                    
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
    
    interface.mouseDown(_touch, [&](string text, string action){
        callback(text, action);
        button = true;
    });
    
    currentTouch = shared_ptr<ofVec2f>(new ofVec2f(getClosestPoint(_touch).x, getClosestPoint(_touch).y));
    
    if(!button)
    {
        if(v && db)
        {
            polygones.erase(polygones.begin() + polygones.size() - 1);
            
            for(int i = polygones.size() - 1; i >= 0; i--)
            {
                if(polygones[i].inside(currentTouch->x, currentTouch->y))
                {
                    polygones.erase(polygones.begin() + i);
                    break;
                }
            }
            
            isDrawing = false;
            isErasing = true;
        }
    }

    down = true;
    
}

void LevelCreator::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    interface.mouseMove(_touch, [&](string text, string action){
        callback(text, action);
    });
    
    currentTouch = shared_ptr<ofVec2f>(new ofVec2f(getClosestPoint(_touch).x, getClosestPoint(_touch).y));
    
    if(!button)
    {
        if(v)
        {
            if(polygones.size() > 0)
            {
                ofPolyline lastPolygone = polygones[polygones.size() - 1];
                
                for(int i = 0; i < lastPolygone.getVertices().size(); i++)
                {
                    ofVec2f currentVertex = lastPolygone.getVertices()[i];
                    ofVec2f firstVertex = lastPolygone.getVertices()[0];
                    
                    if(currentVertex.x == currentTouch->x && currentVertex.y == currentTouch->y && currentVertex != firstVertex)
                    {
                        vector<ofPoint> newVertices = lastPolygone.getVertices();
                        newVertices.erase(newVertices.begin() + i);
                        
                        polygones[polygones.size() - 1].clear();
                        polygones[polygones.size() - 1].addVertices(newVertices);
                        
                        isErasing = true;
                        break;
                    }
                    else if(currentVertex.x == currentTouch->x && currentVertex.y == currentTouch->y && currentVertex == firstVertex)
                    {
                        if(lastPolygone.getVertices().size() == 1)
                        {
                            //If all vertices are erased, erase also the polygone.
                            
                            polygones.erase(polygones.begin() + polygones.size() - 1);
                            isErasing = true;
                            isDrawing = false;
                        }
                    }
                }
            }
        }
        else if(e)
        {
            for(int i = 0; i < emitters.size(); i++)
            {
                float distance = (emitters[i] - ofVec2f(currentTouch->x, currentTouch->y)).length();
                
                if(distance < 70)
                {
                    emitters.erase(emitters.begin() + i);
                    isErasing = true;
                    break;
                }
            }
        }
        else if(r)
        {
            for(int i = 0; i < receptors.size(); i++)
            {
                float distance = (receptors[i] - ofVec2f(currentTouch->x, currentTouch->y)).length();
                
                if(distance < 70)
                {
                    receptors.erase(receptors.begin() + i);
                    isErasing = true;
                    break;
                }
            }
        }
    }
}

void LevelCreator::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    //Interface interactions.
    
    interface.mouseUp(_touch, [&](string text, string action){
        
        if(action == "PRINT")
        {
            printLevel();
        }
        else if(action == "R")
        {
            r = true;
            v = false;
            e = false;
        }
        else if(action == "E")
        {
            r = false;
            v = false;
            e = true;
        }
        else if(action == "V")
        {
            r = false;
            v = true;
            e = false;
        }
        else if(action == "MENU")
        {
            polygones.erase(polygones.begin(), polygones.end());
            emitters.erase(emitters.begin(), emitters.end());
            receptors.erase(receptors.begin(), receptors.end());
        }
        else if(action == "SAVE")
        {
            save();
        }
        
        //Hightlight buttons
        
        vector<shared_ptr<Button>> buttons = interface.getButtons();
        
        if(text == "PRINT" || text == "R" || text == "E" || text == "V")
        {
            for(int i = 0; i < buttons.size(); i++)
            {
                if(text != buttons[i]->getText())
                {
                    buttons[i]->setHighlight(false);
                }else
                {
                    buttons[i]->setHighlight(true);
                }
            }
        }
        
        callback(text, action);
        
    });
    
    //If not interface interaction then check for updating screen.
    
    if(!button)
    {
        if(v && !db && !isErasing)
        {
            //If no polygone exists or the last has been closed, begin another one.
            
            if(polygones.size() == 0 || !isDrawing)
            {
                polygones.push_back(ofPolyline());
                isDrawing = true;
            }
            
            polygones[polygones.size() - 1].addVertex(ofVec2f(currentTouch->x, currentTouch->y));
            
            //Chech if the current touch is the same of the first point of the current polygone.
            //If so then close that polygone and begin anther one.
            
            if(polygones.size() > 0 && polygones[polygones.size() - 1].getVertices().size() > 2)
            {
                ofVec2f firstVertex = polygones[polygones.size() - 1].getVertices()[0];
                
                if(firstVertex.x == currentTouch->x && firstVertex.y == currentTouch->y)
                {
                    isDrawing = false;
                }
                
            }
        
        }
        else if(e && !db && !isErasing)
        {
            emitters.push_back(ofVec2f(currentTouch->x, currentTouch->y));
        }
        else if(r && !db && !isErasing)
        {
            receptors.push_back(ofVec2f(currentTouch->x, currentTouch->y));
        }
    }
    
    db = false;
    down = false;
    button = false;
    
    currentTouch = nullptr;
    isErasing = false;
}

void LevelCreator::onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    
    db = true;
    
}

void LevelCreator::removeLastVertice()
{
    vector<ofPoint> currentVertices = polygones[polygones.size() - 1].getVertices();
    
    //Update vertices
    
    currentVertices.erase(currentVertices.begin() + currentVertices.size() - 1);
    
    //Update current polygone with new vertices.
    //Here we change only the last one to make it follow the finger of the user.
    
    polygones[polygones.size() - 1].clear();
    polygones[polygones.size() - 1].addVertices(currentVertices);
}
