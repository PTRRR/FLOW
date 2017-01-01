precision highp float;

uniform sampler2D tex0;
uniform mat4 rotMatrix;

varying vec2 texCoordVarying;
varying float angle;
varying float alpha;

vec2 texCoord = gl_PointCoord;
float vRotation = 1.0;

void main()
{
    
    //    texCoord = (rotMatrix * vec3(gl_PointCoord.xy, 0));
    //    gl_FragColor = texture2D(tex0, texCoordVarying);
    
    vec4 color = texture2D(tex0, texCoord);
    
    gl_FragColor = vec4(color.rgb, color.a * alpha);
    
    //    float mid = 0.5;
    //    vec2 rotated = vec2(cos(angle) * (gl_PointCoord.x - mid) + sin(angle) * (gl_PointCoord.y - mid) + mid,
    //                        cos(angle) * (gl_PointCoord.y - mid) - sin(angle) * (gl_PointCoord.x - mid) + mid);
    //
    //    vec4 rotatedTexture=texture2D(tex0, rotated);
    //    gl_FragColor =  rotatedTexture;
}