//
//  Receptor.h
//  ofMagnet
//
//  Created by Pietro Alberti on 30.12.16.
//
//

#ifndef Receptor_h
#define Receptor_h

#include <stdio.h>
#include "Actuator.h"

class Receptor : public Actuator {

private:
    
    int particlesCount = 0;
    
public:

    Receptor();
    
    
};

#endif /* Receptor_h */
