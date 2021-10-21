const float PI = 3.14159265359;
const vec2 center = vec2(0.5, 0.5);
const float rotations = 1.0;
const float scale = 8.0;
const vec4 backColor = vec4(0.15, 0.15, 0.15, 1.0);
void main()
{
    vec2 uv = textureCoordinate;
    
    vec4 color = vec4(0.0);
    vec2 difference = uv - center;
    vec2 dir = normalize(difference);
    float dist = length(difference);
    
    float angle = 2.0 * PI * rotations * progress;
    
    float c = cos(angle);
    float s = sin(angle);
    
    float currentScale = mix(scale, 1.0, 2.0 * abs(progress - 0.5));
    
    vec2 rotatedDir = vec2(dir.x  * c - dir.y * s, dir.x * s + dir.y * c);
    vec2 rotatedUv = center + rotatedDir * dist / currentScale;
    
    if (rotatedUv.x < 0.0 || rotatedUv.x > 1.0 ||
        rotatedUv.y < 0.0 || rotatedUv.y > 1.0)
    {
        color = backColor;
    }else
    {
        color = mix(getFromColor(rotatedUv), getToColor(rotatedUv), progress);
    }
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
