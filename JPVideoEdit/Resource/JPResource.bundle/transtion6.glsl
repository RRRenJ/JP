void main()
{
    vec4 fTex = getFromColor(textureCoordinate);
    vec4 tTex = getToColor(textureCoordinate);
    float m = step(distance(fTex, tTex), progress);
    vec4 color = mix(
                     mix(fTex, tTex, m),
                     tTex,
                     pow(progress, 5.0)
                     );
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
