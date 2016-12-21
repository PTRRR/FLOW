//
//  Timer.h
//  ofMagnet
//
//  Created by Pietro Alberti on 21.12.16.
//
//

#ifndef Timer_h
#define Timer_h

#include <stdio.h>
#include "ofxiOS.h"

class Timer {

private:
    
    int currentTime = 0; //millis
    
    vector<function<void ()>> callback;
    vector<int> endTime;
    
public:

    Timer();
    
    void update();
    void setTimeout(function<void ()> _callback, int _millis);
    
};

#endif /* Timer_h */
