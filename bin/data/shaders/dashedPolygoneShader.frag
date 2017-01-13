precision highp float;

uniform sampler2D tex0;
uniform float alpha;

vec2 texCoord = gl_PointCoord;

void main()
{
    
    vec4 color = texture2D(tex0, texCoord);
    
//    float dist = length(vec2(0.5, 0.5) - texCoord);
//    
//    float a = smoothstep(0.5, 0.0, dist);
    
//    gl_FragColor = vec4(1.0, 1.0, 1.0, a * alpha);
    
    gl_FragColor = vec4(color.rgb, color.a * alpha);

}