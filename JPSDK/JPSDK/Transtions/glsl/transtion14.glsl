const float a = 4.0;
const float b = 1.0;
const float amplitude = 120.0;
const float smoothness = 0.1;

void main()
{
    vec2 uv = textureCoordinate;
    vec2 p = uv.xy / vec2(1.0).xy;
    vec2 dir = p - vec2(.5);
    float dist = length(dir);
    float x = (a - b) * cos(progress) + b * cos(progress * ((a / b) - 1.) );
    float y = (a - b) * sin(progress) - b * sin(progress * ((a / b) - 1.));
    vec2 offset = dir * vec2(sin(progress  * dist * amplitude * x), sin(progress * dist * amplitude * y)) / smoothness;
    vec4 color = mix(getFromColor(p + offset), getToColor(p), smoothstep(0.2, 1.0, progress));
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
