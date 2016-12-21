//
//  Timer.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 21.12.16.
//
//

#include "Timer.h"

Timer::Timer(){};

void Timer::update(){
    
    currentTime = ofGetElapsedTimeMillis();
    
    for(int i = callback.size() - 1; i >= 0; i--){
        
        if (currentTime >= endTime[i]) {
            callback[i]();
            
            callback.erase(callback.begin() + i);
            endTime.erase(endTime.begin() + i);
            
        }
        
    }
    
}

void Timer::setTimeout(function<void ()> _callback, int _millis){
    
    callback.push_back(_callback);
    endTime.push_back(currentTime + _millis);
    
}