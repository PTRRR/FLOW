precision highp float;

varying vec3 vBC;
varying vec3 vDistances;

void main()
{
    
    float dist = length(vec3(0.5, 0.5, 0.5) - vBC);
    
//    if(any(lessThan(vBC, vec3(0.02)))){
//        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
//    }
//    else{
//        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
//    }
    
    if(vBC.x * vDistances.x < 20.0) gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    if(vBC.y * vDistances.y < 20.0) gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    if(vBC.z * vDistances.z < 20.0) gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    
//    gl_FragColor.rgb = mix(vec3(0.0), vec3(0.5), edgeFactor());
    
}