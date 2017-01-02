// these are for the programmable pipeline system
uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec4 normal;

// this is something we're creating for this shader

varying float alpha;

void main()
{
    alpha = normal.z;
    gl_Position = modelViewProjectionMatrix * position;
}