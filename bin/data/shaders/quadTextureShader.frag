precision highp float;

uniform sampler2D tex0;
varying vec2 vTexCoords;
varying vec4 vColor;

uniform float alpha;

void main()
{

    vec4 color = texture2D(tex0, vTexCoords / 2.0 - vec2(-0.5, -0.5) );
    gl_FragColor = vec4(color.rgb, color.a * alpha * vColor.a);
    
}