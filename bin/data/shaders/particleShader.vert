attribute vec4 position;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;


void main(){
    
    //finally set the pos to be that actual position rendered
    vec4 newPosition = vec4(position.x + 300.0, position.y, position.z, 1.0);
    gl_Position = newPosition;
    
}