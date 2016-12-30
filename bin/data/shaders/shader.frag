#ifdef GL_ES
// define default precision for float, vec, mat.
precision highp float;
#endif

void main(){
    gl_FragColor = vec4(1.0, gl_FragCoord.x * 0.0005, gl_FragCoord.y * 0.0005, 1.0);
}