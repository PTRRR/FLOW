// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec4 normal;
attribute vec2 texcoord;

// this is something we're creating for this shader
varying vec2 texCoordVarying;
varying float size;
varying float angle;
varying float alpha;

// this is coming from our C++ code
//uniform float mouseX;
//uniform vec2 mouse;

void main()
{
    // here we move the texture coordinates
    texCoordVarying = vec2(texcoord.x, texcoord.y);
    
    size = normal.x;
    angle = normal.y;
    alpha = normal.z;
    // send the vertices to the fragment shader
    gl_PointSize = size;
    gl_Position = modelViewProjectionMatrix * position;
    
    
}