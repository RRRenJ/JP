void main()
{
    vec4 forColor = getFromColor(textureCoordinate);
    vec4 backColor = getToColor(textureCoordinate);
    vec2 oa = (((forColor.rg+forColor.b)*0.5)*2.0-1.0);
    vec2 ob = (((backColor.rg+backColor.b)*0.5)*2.0-1.0);
    vec2 oc = mix(oa,ob,0.5)*0.2;
    float w0 = progress;
    float w1 = 1.0-w0;
    vec4 color = mix(getFromColor(textureCoordinate+oc*w0), getToColor(textureCoordinate-oc*w1), progress);;
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
