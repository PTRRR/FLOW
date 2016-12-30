attribute vec4 position;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;


void main(){
    
    //finally set the pos to be that actual position rendered
    gl_Position = projectionMatrix * modelViewMatrix * position;
    
}
