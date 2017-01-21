//
//  TestScene.mm
//  FLOW
//
//  Created by Pietro Alberti on 14.01.17.
//
//

#include "TestScene.h"

TestScene::TestScene(){}

TestScene::TestScene(shared_ptr<ofTrueTypeFont> _mainFont){

    for(int i = 0; i < 400; i++){
        
        addParticle();
        
    }
    
    polygone = Polygone();
    
    for(int i = 0; i < 10; i++){
        
        float angle = M_PI * 2.0 / 9 * i;
        
        polygone.addVertex(cos(angle) * 200 + ofGetWidth() / 2, sin(angle) * 200 + ofGetHeight() / 2);
        
    }

}

void TestScene::update(){
    
    for(int i = 0; i < particles.size(); i++){
        
        if(particles[i]->isOut()){
            
            particles[i]->setPosition(ofVec2f(ofGetWidth() / 2, 10));
            particles[i]->setVelocity(ofVec2f(ofRandomf(), 0.0));
            
        }
        
        particles[i]->applyForce(ofVec2f(0.0, 0.1));
        particles[i]->update();
        
        if(polygone.insideBoundingBox(particles[i]->getPosition())){
            
            if(polygone.inside(particles[i]->getPosition())){
                
                for(int j = 1; j < polygone.getVertices().size(); j++){
                    
                    ofVec2f currentVertice = polygone.getVertices()[j];
                    ofVec2f lastVertice = polygone.getVertices()[j - 1];
                    ofVec2f particuleDirection = (particles[i]->getPosition() - particles[i]->getLastPosition()).normalize();
                    
                    shared_ptr<ofVec2f> intersection = getIntersection(particles[i]->getLastPosition() - particuleDirection * 100, particles[i]->getPosition(), lastVertice, currentVertice);
                    
                    if(intersection != nullptr){
                        
                        ofVec2f normal = (lastVertice - currentVertice).getPerpendicular();
                        ofVec2f particuleDirection = (particles[i]->getLastPosition() - particles[i]->getPosition()).normalize();
                        float angle = particuleDirection.angleRad(normal);
                        ofVec2f bounceDirection = normal.rotateRad(angle).normalize();
                        
                        particles[i]->setPosition(ofVec2f(intersection->x, intersection->y) + normal * 0.5);
                        particles[i]->setVelocity(particles[i]->getVelocity().length() * bounceDirection * 0.7);
                        
                        beforeImpact.push_back(particles[i]->getLastPosition());
                        impacts.push_back(ofVec2f(intersection->x, intersection->y));
                        inside.push_back(particles[i]->getPosition());
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

void TestScene::renderToScreen(){
    
    ofSetColor(255, 255, 255);
    
    ofNoFill();
    
    ofBeginShape();
    
    for(int i = 0; i < polygone.getVertices().size(); i++){
        
        ofVertex(polygone.getVertices()[i].x, polygone.getVertices()[i].y);
        
    }
    
    ofEndShape();
    
    
    for(int i = 0; i < polygone.getVertices().size(); i++){
        
        
        ofFill();
        ofDrawCircle(polygone.getVertices()[i].x, polygone.getVertices()[i].y, 5);
        
    }
    
    ofSetColor(255, 0, 0);
    
    for(int i = 0; i < particles.size(); i++){
        
        ofDrawCircle(particles[i]->getPosition(), 5);
        
    }
    
    
    
    
//    for(int i = 0; i < impacts.size(); i++){
//        
//        ofSetColor(0, 0, 255);
//        ofDrawCircle(beforeImpact[i], 2);
//        ofSetColor(0, 255, 0);
//        ofDrawCircle(impacts[i], 2);
//        ofSetColor(255, 0, 0);
//        ofDrawCircle(inside[i], 2);
//        
//    }
    
}

shared_ptr<ofVec2f> TestScene::getIntersection(ofVec2f _p1, ofVec2f _p2, ofVec2f _p3, ofVec2f _p4){
    
    // Store the values for fast access and easy
    // equations-to-code conversion
    float x1 = _p1.x, x2 = _p2.x, x3 = _p3.x, x4 = _p4.x;
    float y1 = _p1.y, y2 = _p2.y, y3 = _p3.y, y4 = _p4.y;
    
    float d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    // If d is zero, there is no intersection
    if (d == 0) return nullptr;
    
    // Get the x and y
    float pre = (x1*y2 - y1*x2), post = (x3*y4 - y3*x4);
    float x = ( pre * (x3 - x4) - (x1 - x2) * post ) / d;
    float y = ( pre * (y3 - y4) - (y1 - y2) * post ) / d;
    
    // Check if the x and y coordinates are within both lines
    if ( x < min(x1, x2) || x > max(x1, x2) ||
        x < min(x3, x4) || x > max(x3, x4) ) return nullptr;
    if ( y < min(y1, y2) || y > max(y1, y2) ||
        y < min(y3, y4) || y > max(y3, y4) ) return nullptr;
    
    // Return the point of intersection
    shared_ptr<ofVec2f> intersection = shared_ptr<ofVec2f>(new ofVec2f());
    intersection->x = x;
    intersection->y = y;
    return intersection;
    
}

void TestScene::addParticle(){
    
    shared_ptr<Particle> newParticle = shared_ptr<Particle>(new Particle());
    newParticle->setPosition(ofVec2f(ofGetWidth() / 2, 10));
    newParticle->setMaxVelocity(1000000);
    newParticle->setMass(1);
    newParticle->setDamping(1);
    newParticle->setVelocity(ofVec2f(ofRandomf(), 0.0));
    newParticle->setBox(0, 0, ofGetWidth(), ofGetHeight());
    
    particles.push_back(newParticle);
    
}

//Player inputs
//These inputs will only fire when this screen is active

void TestScene::onMouseDown(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    

    
}

void TestScene::onMouseUp(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    

    
}

void TestScene::onMouseMove(ofTouchEventArgs & _touch, function<void(string _text, string _action)> _callback){
    

    
}

void TestScene::onDoubleClick(ofTouchEventArgs & _touch, function<void(string _text, string _action)> callback){
    

    
}