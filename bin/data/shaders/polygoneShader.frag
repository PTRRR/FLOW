#extension GL_OES_standard_derivatives : enable
precision highp float;

varying vec4 vColor;
varying vec3 vBC;

float edgeFactor(){
    vec3 d = fwidth(vBC);
    vec3 a3 = smoothstep(vec3(0.0), d*1.5, vBC);
    return min(min(a3.x, a3.y), a3.z);
}

void main()
{
    gl_FragColor = vec4(vBC, 1.0);
}