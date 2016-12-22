//
//  Scene.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 17.12.16.
//
//

#include "Scene.h"

Scene::Scene(){}

Scene::Scene(shared_ptr<ofTrueTypeFont> _mainFont){
    
    time = 0.0f;
    
    //Create the user interface : MENU button
    
    interface = Interface(_mainFont);
    interface.addButton("MENU", "MENU", ofVec2f(ofGetWidth() - _mainFont->stringWidth("MENU"), 30));
    
    //Load the shader in order to draw the background
    //This shader will draw the contours of the magnetic field
    
//    loadBackgroundShader();
    
    //Create the camera for the scene
    //The aspect ration is determined from the screen size
    
//    camera.setAspectRatio(0.75f);
//    camera.setFov(60);
    
    //Create the flow field that will guide the particles trhough the scene
    //The flow field contains references to the magnets and calculate the "magnetic field" in each points of the screen
    
    flowField = shared_ptr<FlowField>(new FlowField(30, 30));
    
    //Initialize the emitter
    
    particleSystem.setPosition(ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2));
    particleSystem.setEmissionRate(60);
    
    //Initialize the receptor
    
    receptor = shared_ptr<Receptor>(new Receptor());
    receptor->setPosition(ofVec2f(ofGetWidth() / 2, ofGetHeight()));
    receptor->setRadius(30.0f);
    
    //The receptor is a child of magnet in order to attrack slightly the particles toward it
    
    receptor->setStrength(-2.5f);
    receptor->setRadiusOfAction(100.0f);
    magnets.push_back(receptor);
    flowField->addMagnet(receptor);
    
    //Set up some magnets
    
    addMagnet(ofVec2f(ofGetWidth() / 2, 20.0f), 10.0f, 200.0f);
    addMagnet(ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 - 300), 1.0f, 300.0f);
    addMagnet(ofVec2f(ofGetWidth() / 2, ofGetHeight() / 2 + 300), 1.0f, 300.0f);
    
};

//Where all the scene is rendered
void Scene::renderToFbo(){
    
    ofClear(0, 0, 0);
    ofPushStyle();
    ofSetColor(0, 0, 0);
    ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
    ofPopStyle();
    
    //Update the uniforms on the fragment shader
    
//    updateBackgroudShader();
    
    //Bind the shader to draw the background
    
//    gl::Context::getCurrent()->pushGlslProg();
//    gl::Context::getCurrent()->bindGlslProg(backGroundShader);
    
    //Draw the background with a solid rect
    
    //    gl::drawSolidRect(Rectf(0.0f, 0.0f, getWindowWidth(), getWindowHeight()));
    
    //Unbind the background shader and restore last shader
    
//    gl::Context::getCurrent()->popGlslProg();
    
    //Debug draw
    
    for(int i = 0; i < magnets.size(); i++){
        
        magnets[i]->debugDraw();
        
    }
    
    //    gl::setMatrices(camera);
    //
    //    camera.lookAt(vec3(0.0f, 0.0f, 10.0f), vec3(0));
    
    //Draw the emitter
    
    particleSystem.display();
    
    //Draw the receptor
    
    receptor->display();
    
    //Reset
    //matrices before drawing the interface
    
//    gl::setMatricesWindow(getWindowSize());
    
    //Draw the flow field
    //This drawing function draws the flow fiels with a grid of arrows
    
    //    flowField->debugDraw();
    
    //Lastly draw the user interface on top of all others objecs
    
    interface.draw();
    
}

void Scene::update(){
    
    time += ofGetElapsedTimeMillis();
    
    //Update the emitter : add particles and update their position
    
    particleSystem.update();
    
    //Apply some forces to these particles
    
    particleSystem.applyForceToParticles(ofVec2f(0.0f, 0.0f));
    particleSystem.applyForceToParticles(flowField);
    
    if(currentMagnet != nullptr){
        
        ofVec2f newCurrentMagnetPosition = currentMagnet->getPosition();
        newCurrentMagnetPosition += (currentMagnetTarget - newCurrentMagnetPosition) * 0.13f;
        
        currentMagnet->setPosition(newCurrentMagnetPosition);
        
    }
    
    //Remove particles when they hit the receptor
    
    vector<shared_ptr<Particle>> particles = particleSystem.getParticles();
    
    for(int i = 0; i < particles.size(); i++){
        
        float distance = (receptor->getPosition() - particles[i]->getPosition()).length();
        
        if (distance < 100) {
            
            particleSystem.removeParticle(particles[i]);
            receptor->setCount(receptor->getCount() + 1);
            
            if(receptor->getCount() >= 100){
                
                if(levelEndCallback != nullptr) levelEndCallback();
                
            }
            
        }
        
    }
    
}

//Player inputs
//These inputs will only fire when this screen is active

void Scene::onMouseDown(ofVec2f _position, function<void(string _text, string _action)> _callback){

    for(int i = 0; i < magnets.size(); i++){
        
        //Check the distance with each magnets
        
        float distance = ofVec2f(magnets[i]->getPosition() - _position).length();
        
        //If the distance between the mouse and a magnet is less than 20.0 set the reference
        // to current magnet variable and break the loop to take only this magnet
        
        if(distance < 50.0f){
            
            cout << "adsk" << endl;
            currentMagnet = magnets[i];
            currentMagnetTarget = _position;
            break;
            
        }
        
    }
    
    interface.mouseDown(_position, [&](string _text, string _action){
        _callback(_text, _action);
    });
    
}

void Scene::onMouseUp(ofVec2f _position, function<void(string _text, string _action)> _callback){
    
    interface.mouseUp(_position, [&](string _text, string _action){
        _callback(_text, _action);
    });
    
}

void Scene::onMouseMove(ofVec2f _position, function<void(string _text, string _action)> _callback){
    
//    backGroundShader->uniform("uMouse", _position);
    if(currentMagnet != nullptr){
        
        currentMagnetTarget = _position;
        
    }
    
}

void Scene::onMouseDrag(ofVec2f _position, function<void(string _text, string _action)> _callback){
    
    
    
}

//Utility to add some magnets to the scene and in the flow field
//This takes care of storing references of the magnets in the scene and the flow field

void Scene::addMagnet(ofVec2f _position, float _strength, float _radiusOfAction){
    
    shared_ptr<Magnet> newMagnet (new Magnet());
    
    newMagnet->setPosition(_position);
    newMagnet->setStrength(_strength);
//    newMagnet->setBoundingBox(Rectf(0.0f, 0.0f, getWindowWidth(), getWindowHeight()));
    newMagnet->setRadiusOfAction(_radiusOfAction);
    newMagnet->setMaxVelocity(10.0f);
    newMagnet->setMass(2.0f);
    newMagnet->setLimitToBoundingBox(true);
    
    //Store the reference in both places
    
    flowField->addMagnet(newMagnet);
    magnets.push_back(newMagnet);
    
}

//Load backgroud shader
//This function loads and pass some uniforms to the shader : screen resolution, max number of magnets

//void Scene::loadBackgroundShader(){
//    
//    //Create the shader program for the background
//    
//    backGroundShader = gl::GlslProg::create(gl::GlslProg::Format().vertex(loadResource("LevelCurves.vert")).fragment(loadResource("LevelCurves.frag")));
//    
//    //Pass some uniforms to the shader
//    //The max number of magnets is useful to set the array of magnets in the fragment shader
//    
//    backGroundShader->uniform("uMaxNumber", MAX_MAGNET_NUM);
//    backGroundShader->uniform("uScreenResolution", vec2(getWindowWidth(), getWindowHeight()));
//    
//}

//Update uniforms in the fragment shader
//The position of the magnets and their strength

//void Scene::updateBackgroudShader(){
//    
//    for (int i = 0; i < magnets.size(); i++) {
//        
//        //Set uTime
//        backGroundShader->uniform("uTime", time);
//        
//        //Set uMagnetPos
//        string magnetPosIndex = "uMagnetPos[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetPosIndex, magnets[i]->getPosition());
//        
//        //Set uMagnetStrength
//        string magnetStrengthIndex = "uMagnetStrength[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetStrengthIndex, magnets[i]->getStrength());
//        
//        //Set uMagnetRadiusOfAction
//        string magnetRadiusIndex = "uMagnetRadius[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetRadiusIndex, magnets[i]->getRadius());
//        
//        //Set uMagnetRadiusOfAction
//        string magnetRadiusOfActionIndex = "uMagnetRadiusOfAction[" + to_string(i) + "]";
//        backGroundShader->uniform(magnetRadiusOfActionIndex, magnets[i]->getRadiusOfAction());
//        
//    }
//    
//}

void Scene::onEnd(function<void ()> _levelEndCallback){
    
    levelEndCallback = _levelEndCallback;
    
}

//This function loads a scene from a XML file
//All levels are contained in a XML file

void Scene::XMLSetup(){
    
    
    
}