const float smoothness = 0.3;
const int opening = 1;
const vec2 center = vec2(0.5, 0.5);
const float SQRT_2 = 1.414213562373;
void main()
{
    vec2 uv = textureCoordinate;
    float x = opening == 1 ? progress : 1.-progress;
    float m = smoothstep(-smoothness, 0.0, SQRT_2*distance(center, uv) - x*(1.+smoothness));
    vec4 color =  mix(getFromColor(uv), getToColor(uv), opening == 1 ? 1.-m : m);
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
