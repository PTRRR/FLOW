precision highp float;

uniform sampler2D tex0;
uniform float alpha;

varying vec4 vColor;
varying vec2 vTexCoord;

void main()
{
    
    float a = smoothstep(0.4, 0.0, abs(vTexCoord.y - 0.5));
    gl_FragColor = vec4(vColor.rgb, vColor.a * a * alpha);
    
}