void main()
{
    vec4 forColor = getFromColor(textureCoordinate);
    vec4 backColor = getToColor(textureCoordinate);
    vec4 color = mix(forColor, backColor, progress);
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
