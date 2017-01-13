// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec4 normal;
attribute vec2 texcoord;

// this is something we're creating for this shader
varying vec2 vTexCoords;
varying vec2 vTexCoordsOffseted;
varying float vRadius;
varying float percentFilled;

void main()
{
    
    vTexCoords = texcoord;
    
    //offset coordinates to begin the circle on top.
    
    if(vTexCoords.x == -1.0 && vTexCoords.y == -1.0){
        vTexCoordsOffseted = vec2(-1.0, 1.0);
    }else if(vTexCoords.x == 1.0 && vTexCoords.y == -1.0){
        vTexCoordsOffseted = vec2(-1.0, -1.0);
    }else if(vTexCoords.x == 1.0 && vTexCoords.y == 1.0){
        vTexCoordsOffseted = vec2(1.0, -1.0);
    }else if(vTexCoords.x == -1.0 && vTexCoords.y == 1.0){
        vTexCoordsOffseted = vec2(1.0, 1.0);
    }
    
    vRadius = normal.x;
    percentFilled = normal.y;
    gl_Position = modelViewProjectionMatrix * position;
    
}