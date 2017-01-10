precision highp float;

varying vec3 vBC;
varying vec3 vDistances;

void main()
{
    
    float lineWidth = 10.0;
    
    float dist1 = vBC.x * vDistances.x;
    float dist2 = vBC.y * vDistances.y;
    float dist3 = vBC.z * vDistances.z;
    
    vec4 fragment = vec4(1.0, 1.0, 1.0, 1.0);
    
    
    
    if(dist1 < lineWidth){
     
        float v = smoothstep( lineWidth / 2.0, 0.0, abs( (lineWidth / 2.0) - dist1) );
        fragment.a *= v;
        
    }
    
    if(dist2 < lineWidth){
    
        float v = smoothstep( lineWidth / 2.0, 0.0, abs( (lineWidth / 2.0) - dist2) );
        fragment.a *= v;
    
    }

    if(dist3 < lineWidth){

        float v = smoothstep( lineWidth / 2.0, 0.0, abs( (lineWidth / 2.0) - dist3) );
        fragment.a *= v;
        
    }

    gl_FragColor = fragment;
    
}