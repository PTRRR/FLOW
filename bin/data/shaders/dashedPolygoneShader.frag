precision highp float;

uniform sampler2D tex0;
uniform float alpha;

vec2 texCoord = gl_PointCoord;

void main()
{
    
    vec4 color = texture2D(tex0, texCoord);
    gl_FragColor = vec4(color.rgb, color.a * alpha);

}