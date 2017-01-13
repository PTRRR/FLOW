precision highp float;

uniform sampler2D tex0;

varying vec2 vTexCoord;
varying vec3 vBC;
varying vec3 vDistances;

uniform float alpha;

void main()
{
    
    vec4 color = texture2D(tex0, vTexCoord);
    vec4 fragment = vec4(color.rgb, color.a * alpha);
    
    
//    float lineWidth = 10.0;
//
//    float dist1 = vBC.x * vDistances.x;
//    float dist2 = vBC.y * vDistances.y;
//    float dist3 = vBC.z * vDistances.z;
//
//    vec4 fragment = vec4(1.0, 1.0, 1.0, 1.0);
//
//    if(dist1 < lineWidth){
//     
//        float v = smoothstep( lineWidth / 2.0, 0.0, abs( (lineWidth / 2.0) - dist1) );
//        fragment.a *= v;
//        
//    }
//    
//    if(dist2 < lineWidth){
//    
//        float v = smoothstep( lineWidth / 2.0, 0.0, abs( (lineWidth / 2.0) - dist2) );
//        fragment.a *= v;
//    
//    }
//
//    if(dist3 < lineWidth){
//
//        float v = smoothstep( lineWidth / 2.0, 0.0, abs( (lineWidth / 2.0) - dist3) );
//        fragment.a *= v;
//        
//    }
//
//    fragment.a *= alpha;
//    
//    gl_FragColor = fragment;
    
    float lineWidth = 20.0;
    float midLineWidth = lineWidth * 0.5;
    
    float dist1 = vBC.x * vDistances.x;
    float dist2 = vBC.y * vDistances.y;
    float dist3 = vBC.z * vDistances.z;

//    if(dist1 < lineWidth * 0.5){
//    
//        float v = smoothstep( lineWidth * 0.5, 0.0, abs(lineWidth * 0.5 - dist1) );
//        fragment.a *= v;
//    
//    }else if(dist1 > lineWidth * 0.5 && dist2 > lineWidth * 0.5){
//        
//        
//        float v1 = smoothstep( 50.0, 0.0, abs(lineWidth * 0.5 - dist1) );
//        float v2 = smoothstep( 50.0, 0.0, abs(lineWidth * 0.5 - dist2) );
//        fragment.a *= v1 * v2;
//        
//    }
    
//    if(dist1 > lineWidth * 0.5 && dist2 > lineWidth * 0.5 && dist3 > lineWidth * 0.5){
//        
//        fragment.a *= (1.0 - dist1 / 5.0) * (1.0 - dist2 / 5.0) * (1.0 - dist3 / 5.0);
//        
//    }else{
//        
//        fragment.a = 1.0;
//        
//    }
    
    if(dist1 < lineWidth && dist2 > lineWidth && dist3 > lineWidth){ //Line 1
        
        float v = smoothstep(lineWidth, 0.0, dist1);
        
        fragment.a *= v;
        
    }else if(dist1 > lineWidth && dist2 < lineWidth && dist3 > lineWidth){ //Line 2
        
        float v = smoothstep(lineWidth, 0.0, dist2);
        
        fragment.a *= v;
        
    }else if(dist1 > lineWidth && dist2 > lineWidth && dist3 < lineWidth){ // Line 3
        
        float v = smoothstep(lineWidth, 0.0, dist3);
        
        fragment.a *= v;
        
    }else if(dist1 < lineWidth && dist2 < lineWidth && dist3 > lineWidth){ // Angle 1
        
        float v1 = smoothstep(lineWidth, 0.0, dist1);
        float v2 = smoothstep(lineWidth, 0.0, dist2);
        
        fragment.a *= (v1 + v2);
        
    }else if(dist1 > lineWidth && dist2 < lineWidth && dist3 < lineWidth){ // Angle 2
        
        float v1 = smoothstep(lineWidth, 0.0, dist2);
        float v2 = smoothstep(lineWidth, 0.0, dist3);
        
        fragment.a *= (v1 + v2);
        
    }else if(dist1 < lineWidth && dist2 > lineWidth && dist3 < lineWidth){ // Angle 3
        
        float v1 = smoothstep(lineWidth, 0.0, dist1);
        float v2 = smoothstep(lineWidth, 0.0, dist3);
        
        fragment.a *= (v1 + v2);
        
    }else{
        
        fragment.a *= 0.0;
        
    }
    
//    if(dist2 < lineWidth * 0.5){
//        
//        float v = smoothstep( lineWidth * 0.5, 0.0, abs(lineWidth * 0.5 - dist2) );
//        fragment.a *= v;
//        
//    }else{
//        
//        float v = smoothstep( 50.0, 0.0, abs(lineWidth * 0.5 - dist2) );
//        fragment.a *= v;
//        
//    }
    
//    if(dist2 < lineWidth){
//    
//        float v = smoothstep(0.0, lineWidth, dist2);
//        fragment.a *= v;
//    
//    }
//    
//    if(dist3 < lineWidth){
//    
//        float v = smoothstep(0.0, lineWidth, dist3);
//        fragment.a *= v;
//         
//    }
    
    fragment.a *= alpha;
     
    gl_FragColor = fragment;
    
}