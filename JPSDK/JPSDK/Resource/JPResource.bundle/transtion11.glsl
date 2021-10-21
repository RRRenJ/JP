const float PI = 3.141592653589;
const float smoothness = 1.0;
void main()
{
    vec2 p = textureCoordinate;
    vec2 rp = p*2.-1.;
    vec4 color = mix(
                     getToColor(p),
                     getFromColor(p),
                     smoothstep(0., smoothness, atan(rp.y,rp.x) - (progress-.5) * PI * 2.5)
                     );
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
