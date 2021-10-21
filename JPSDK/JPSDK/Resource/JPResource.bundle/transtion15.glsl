float colorSeparation = 0.04;
void main()
{
    vec2 uv = textureCoordinate;
    vec4 color = vec4(0.0);
    float y = 0.5 + (uv.y-0.5) / (1.0-progress);
    if (y < 0.0 || y > 1.0) {
        color = getToColor(uv);
    }
    else {
        vec2 fp = vec2(uv.x, y);
        vec2 off = progress * vec2(0.0, colorSeparation);
        vec4 c = getFromColor(fp);
        vec4 cn = getFromColor(fp - off);
        vec4 cp = getFromColor(fp + off);
        color = vec4(cn.r, c.g, cp.b, c.a);
    }
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
