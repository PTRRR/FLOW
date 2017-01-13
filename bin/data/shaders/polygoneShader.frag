precision highp float;

uniform sampler2D tex0;

varying vec2 vTexCoord;
varying vec3 vBC;
varying vec3 vDistances;

uniform float alpha;

void main()
{
    
//    float lineWidth = 10.0;
//    
//    float dist1 = vBC.x * vDistances.x;
//    float dist2 = vBC.y * vDistances.y;
//    float dist3 = vBC.z * vDistances.z;
//    
//    vec4 fragment = vec4(1.0, 1.0, 1.0, 1.0);
    
    vec4 color = texture2D(tex0, vTexCoords / 2.0 - vec2(-0.5, -0.5) );
    gl_FragColor = vec4(color.rgb, color.a * alpha);
    
    
    
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
    
}