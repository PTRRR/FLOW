#ifdef GL_ES
// define default precision for float, vec, mat.
precision highp float;
#endif

uniform vec3 center;
uniform float lineWidth;

void main(){
    
    float maxDist = 100.0;
    float distance = length(vec3(center - gl_FragCoord.xyz));
    float c = smoothstep(lineWidth, lineWidth - 1.2, abs(distance - maxDist + lineWidth));
    gl_FragColor = vec4(1.0, 1.0, 1.0, c);
    
}