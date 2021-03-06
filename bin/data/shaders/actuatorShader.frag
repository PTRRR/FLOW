precision highp float;

uniform sampler2D tex0;
varying vec2 vTexCoords;
varying float vRadius;
varying vec4 vColor;

void main()
{
    
//    vec4 color = texture2D(tex0, (vTexCoords * (vRadius * 0.0025)) - vec2(-0.5, -0.5) );

    vec4 color = texture2D(tex0, vTexCoords / 2.0 - vec2(-0.5, -0.5) );
    gl_FragColor = vec4(color.rgb, color.a * vColor.a);
    
}