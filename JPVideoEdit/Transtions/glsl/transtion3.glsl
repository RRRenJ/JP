void main()
{
    
    if (textureCoordinate.x > (1.0 - progress)){
        vec4 color = getToColor(textureCoordinate);
        if (isY == 1)
        {
            gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
        }else{
            gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
        }
    }else{
        vec4 color = getFromColor(textureCoordinate);
        if (isY == 1)
        {
            gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
        }else{
            gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
        }
    }
}
