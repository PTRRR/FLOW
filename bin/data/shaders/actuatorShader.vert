// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texcoord;

// this is something we're creating for this shader
varying vec2 vTexCoords;

void main()
{
    vTexCoords = texcoord;
    
    gl_PointSize = normal.x * 2.0;
    gl_Position = modelViewProjectionMatrix * position;
}