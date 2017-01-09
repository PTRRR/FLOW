precision highp float;

uniform sampler2D tex0;
varying vec2 vTexCoords;
varying float vRadius;
varying vec4 vColor;

float lineWidth = 5.0;
float innerRadius = 15.0;

void main()
{
    
    vec4 color = texture2D(tex0, (vTexCoords * (vRadius * 0.0025)) - vec2(-0.5, -0.5) );
    gl_FragColor = vec4(color.rgb, color.a * vColor.a);
    
    vec4 fragment = vec4(0.0, 0.0, 0.0, 0.0);
    
    float dist = length(vTexCoords) * vRadius;
    float angle = atan(vTexCoords.y, vTexCoords.x);
    
    if(dist < vRadius && dist > vRadius - lineWidth){
        
        //Draw circle
        
        float c = smoothstep( (lineWidth * 0.5), ( (lineWidth) * 0.0 ), abs( (vRadius - lineWidth * 0.5) - dist) );
        
        gl_FragColor = vec4(c, c, c, c * vColor.a);
        
    }
    
}