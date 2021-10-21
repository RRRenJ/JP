void main()
{
    vec2 ratio2 = vec2(1.0, 1.0 / ratio);
    float s = pow(2.0 * abs(progress - 0.5), 3.0);
    float dist = length((vec2(textureCoordinate) - 0.5) * ratio2);
    vec4 bgcolor = vec4(0.0);
    if (isY == 1)
    {
        bgcolor = vec4(0.0, 0.0, 0.0, 1.0);
    }else{
        bgcolor = vec4(0.5, 0.5, 0.0, 1.0);
    }
    
    vec4 color = mix(
                     progress < 0.5 ? getFromColor(textureCoordinate) : getToColor(textureCoordinate),
                     bgcolor,
                     step(s, dist)
                     );
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
