void main()
{
    float Radius = 1.0;
    
    float T = progress;
    vec2 UV = textureCoordinate;
    UV -= vec2( 0.5, 0.5 );
    
    float Dist = length(UV);
    
    if ( Dist < Radius )
    {
        float Percent = (Radius - Dist) / Radius;
        float A = ( T <= 0.5 ) ? mix( 0.0, 1.0, T/0.5 ) : mix( 1.0, 0.0, (T-0.5)/0.5 );
        float Theta = Percent * Percent * A * 8.0 * 3.14159;
        float S = sin( Theta );
        float C = cos( Theta );
        UV = vec2( dot(UV, vec2(C, -S)), dot(UV, vec2(S, C)) );
    }
    UV += vec2( 0.5, 0.5 );
    
    vec4 C0 = getFromColor(UV);
    vec4 C1 = getToColor(UV);
    vec4 color = mix( C0, C1, T );
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
