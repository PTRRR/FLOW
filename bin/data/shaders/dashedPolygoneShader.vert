// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec4 normal;
attribute vec2 texcoord;

// this is something we're creating for this shader
varying vec2 texCoordVarying;

void main()
{
    // here we move the texture coordinates
    texCoordVarying = vec2(texcoord.x, texcoord.y);

    // send the vertices to the fragment shader
//    gl_PointSize = normal.x;
    gl_PointSize = 6.0;
    gl_Position = modelViewProjectionMatrix * position;
    
    
}