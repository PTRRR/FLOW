// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

// this is something we're creating for this shader

varying vec3 vDistances;
varying vec3 vBC;

void main()
{
    
    vDistances = normal;
    vBC = color.rgb;
    gl_Position = modelViewProjectionMatrix * position;
    
}