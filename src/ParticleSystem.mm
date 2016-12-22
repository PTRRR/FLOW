//
//  ParticleSystem.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 22.12.16.
//
//

#include "ParticleSystem.h"

ParticleSystem::ParticleSystem(){};

void ParticleSystem::initialize(){
    
    for(int i = 0; i < particles.size(); i++){
        
        shared_ptr<Particle> cM = particles[i];
        cM->setPosition(this->position);
        
    }
    
    //Initialize all variables
    elapsedTime = 0.0f;
    currentTime = 0.0f;
    lastTime = 0.0f;
    deltatime = 0.0f;
    
    //Initialize object
    
}

void ParticleSystem::update(){
    
    BaseElement::update();
    
    //Determine the delta time between two updates
    
    currentTime = ofGetElapsedTimeMillis();
    deltatime = currentTime - lastTime;
    
    //The elapsed time is incremented every updates.
    //It's set to zero when he's greater than the update rate
    
    elapsedTime += deltatime;
    
    //How many times the emitter size will be updated in on second according to the
    //update rate variable.
    
    int updateTimesPerSec = 1000 / updateRate;
    
    //When the elapsed time is greater than the update rate, increment the variable "toEmit".
    //The elapsed time is then set to zero to restart the timeout.
    
    if(elapsedTime > updateRate){
        
        //This keeps track of the additional time. This keeps the value "elapsedTime" under 1000.
        
        elapsedTime -= floor(elapsedTime / updateRate) * updateRate;
        
        //Increment toEmit to determine how many particles should be added to the emitter every
        //(updateRate) milliseconds.
        
        toEmit += (float) emissionRate / updateTimesPerSec;
        
        //If the variable to emit is greater than one, add particles.
        //The number to add is determined by the floored value of toEmit since toEmit is a floating
        //value.
        //Then we subtrack the emitted number of particules to the "toEmit" variable
        
        if(floor(toEmit) >= 1){
            
            addParticles(floor(toEmit));
            toEmit -= floor(toEmit);
            
        }
        
    }
    
    //Here, all particles are updated (position, velocity, acceleration, etc...).
    
    for(int i = particles.size() - 1; i >= 0; i--){
        
        if(particles[i]->isOut() || particles[i]->isDead()){
            
            particles.erase(particles.begin() + i);
            
        }
        else{
            
            //Separation algorithme
            //Check the distance with all other particles and apply force if some are too close
            //from each other
            
            float maxDist = 15.0f;
            
            particles[i]->update();
            
            for(int j = 0; j < particles.size(); j++){
                
                if(particles[i] != particles[j]){
                    
                    ofVec2f direction = particles[i]->getPosition() - particles[j]->getPosition();
                    float dist = direction.length();
                    
                    if(dist < maxDist){
                        
                        particles[i]->applyForce(direction * (dist / maxDist) * 0.01f);
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    //Update the lastTime value
    
    lastTime = currentTime;
    
}

//Public function to add particles

void ParticleSystem::addParticles(int num){
    
    for(int i = 0; i < num; i++){
        
        //Set a offset to let the particles leave the screen before they are removed
        
        float offsetBoundingBox = 150.0f;
        
        shared_ptr<Particle> newParticle(new Particle());
        newParticle->setPosition(position);
        newParticle->setVelocity(ofVec2f(ofRandomf() - 0.5f, ofRandomf() - 0.5f));
        newParticle->setMass(1.0f + ofRandomf() * 10.0f);
        newParticle->setMaxVelocity(3.0f);
//        newParticle->setBoundingBox(Rectf(-offsetBoundingBox, -offsetBoundingBox, getWindowWidth() + offsetBoundingBox, getWindowHeight() + offsetBoundingBox));
        particles.push_back(newParticle);
        
    }
    
}

void ParticleSystem::applyForceToParticles(ofVec2f _force){
    
    for(int i = 0; i < particles.size(); i++){
        
        particles[i]->applyForce(_force);
        
    }
    
}

void ParticleSystem::applyForceToParticles(shared_ptr<FlowField> _flowField){
    
    for(int i = 0; i < particles.size(); i++){
        
        particles[i]->applyForce(_flowField->getForceAtPoint(particles[i]->getPosition()));
        
    }
    
}

void ParticleSystem::display(){
    
    
//    gl::begin(GL_LINES);
    
    for(int i = 0; i < particles.size(); i++){
        
//        gl::enableAdditiveBlending();
//        vector<vec2> points = particles[i]->getPoints();
//        
//        for(int p = points.size() - 1; p > 0; p-=1){
//            
//            gl::color(1.0f, 1.0f, 1.0f, particles[i]->getLifeSpan() / particles[i]->getTotalLife());
//            gl::vertex(points[p].x, points[p].y);
//            gl::vertex(points[p - 1].x, points[p - 1].y);
//            
//        }
        
        particles[i]->display();
        
    }
    
//    gl::end();
    
//    gl::drawSolidCircle(position, 5);
    
}

//Set
void ParticleSystem::setRadius(float _radius){
    
    this->radius = _radius;
    
}

void ParticleSystem::setEmissionRate(float _emissionRate){
    
    emissionRate = _emissionRate;
    
}

void ParticleSystem::removeParticle(shared_ptr<Particle> _particle){
    
    for(int i = particles.size() - 1; i >= 0; i--){
        
        if(particles[i] == _particle){
            
            particles.erase(particles.begin() + i);
            break;
            
        }
        
    }
    
}

//Get
float ParticleSystem::getRadius(){
    
    return radius;
    
}

float ParticleSystem::getEmissionRate(){
    
    return emissionRate;
    
}

vector<shared_ptr<Particle>> ParticleSystem::getParticles(){
    
    return particles;
    
}