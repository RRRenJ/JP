vec2 offset(float progress, float x, float theta) {
    float phase = progress*progress + progress + theta;
    float shifty = 0.03*progress*cos(10.0*(progress+x));
    return vec2(0, shifty);
}
void main()
{
    vec4 colors = mix(getFromColor(textureCoordinate + offset(progress, textureCoordinate.x, 0.0)), getToColor(textureCoordinate + offset(1.0-progress, textureCoordinate.x, 3.14)), progress);
    if (isY == 1)
    {
        gl_FragColor = vec4(colors.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(colors.r, colors.g, 0.0, 1.0);
    }
}
