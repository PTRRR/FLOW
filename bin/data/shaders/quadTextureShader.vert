// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec2 texcoord;
attribute vec4 color;

// this is something we're creating for this shader
varying vec2 vTexCoords;
varying vec4 vColor;

void main()
{
    
    vColor = color;
    vTexCoords = texcoord;
    gl_Position = modelViewProjectionMatrix * position;
    
}