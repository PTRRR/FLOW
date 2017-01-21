// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec4 normal;
attribute vec2 texcoord;

// this is something we're creating for this shader
varying vec2 vTexCoord;
varying vec4 vColor;

void main()
{
    // here we move the texture coordinates
    vColor = color;
    vTexCoord = texcoord;
    gl_Position = modelViewProjectionMatrix * position;
    
}