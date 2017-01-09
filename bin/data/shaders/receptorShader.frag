precision highp float;

float M_PI = 3.1415926535897932384626433832795;

uniform sampler2D tex0;
varying vec2 vTexCoords;
varying vec2 vTexCoordsOffseted;
varying float vRadius;
varying vec4 vColor;
varying float percentFilled;

float lineWidth = 3.0;
float innerRadius = 15.0;

void main(){
    
    float dist = length(vTexCoords) * vRadius;
    float angleOffset = M_PI * 0.5;
    
    float angle = atan(vTexCoordsOffseted.y, vTexCoordsOffseted.x) + M_PI;
    
    //Draw texture
    
    vec4 color = texture2D(tex0, (vTexCoords * (vRadius * 0.004)) - vec2(-0.5, -0.5) );
    gl_FragColor = vec4(color.rgb, color.a * vColor.a);
    
    //Draw circle
    
    float customRadius = vRadius * 0.8;
    
    if(dist < customRadius - 30.0 && dist > customRadius - 30.0 - lineWidth){
        
        if( angle < (M_PI * 2.0 * percentFilled)){
            float c1 = smoothstep( (lineWidth * 0.5), ( (lineWidth) * 0.0 ), abs( (customRadius - 30.0 - lineWidth * 0.5) - dist ) );
            gl_FragColor = vec4(c1, c1, c1, c1 * vColor.a);
        }
        
    }
    
    if(dist < customRadius && dist > customRadius - lineWidth){
        
        if( angle < (M_PI * 2.0 * percentFilled)){
            float c1 = smoothstep( (lineWidth * 0.5), ( (lineWidth) * 0.0 ), abs( (customRadius - lineWidth * 0.5) - dist ) );
            gl_FragColor = vec4(c1, c1, c1, c1 * vColor.a);
        }
        
    }
    
}