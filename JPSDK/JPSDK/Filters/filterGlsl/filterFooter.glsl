void main()
{
    highp vec4 color = vec4(0.0);
    color = texture2D(inputImageTexture, textureCoordinate);
    gl_FragColor = filterColor(color);
}
