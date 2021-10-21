void main()
{
    vec2 uv = textureCoordinate;
    vec4 bgcolor = vec4(0.0);
    if (isY == 1)
    {
        bgcolor = vec4(0.0, 0.0, 0.0, 1.0);
    }else{
        bgcolor = vec4(0.5, 0.5, 0.0, 1.0);
    }
    vec4 color = vec4(0.0);
    if (progress <= 0.5) {
        color = getFromColor(uv),
        color = mix(color, bgcolor, progress/0.5);
    }else{
        color = getToColor(uv),
        color = mix(color, bgcolor, (1.0 - progress) / 0.5);
    }
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
