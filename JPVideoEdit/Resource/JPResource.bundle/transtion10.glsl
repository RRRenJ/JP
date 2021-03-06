const ivec2 size = ivec2(4);
const float pause = 0.1;
const float dividerWidth = 0.05;
const float randomness = 0.1;

float rand (vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float getDelta(vec2 p) {
    vec2 rectanglePos = floor(vec2(size) * p);
    vec2 rectangleSize = vec2(1.0 / vec2(size).x, 1.0 / vec2(size).y);
    float top = rectangleSize.y * (rectanglePos.y + 1.0);
    float bottom = rectangleSize.y * rectanglePos.y;
    float left = rectangleSize.x * rectanglePos.x;
    float right = rectangleSize.x * (rectanglePos.x + 1.0);
    float minX = min(abs(p.x - left), abs(p.x - right));
    float minY = min(abs(p.y - top), abs(p.y - bottom));
    return min(minX, minY);
}

float getDividerSize() {
    vec2 rectangleSize = vec2(1.0 / vec2(size).x, 1.0 / vec2(size).y);
    return min(rectangleSize.x, rectangleSize.y) * dividerWidth;
}
void main()
{
    vec4 bgcolor = vec4(0.0);
    if (isY == 1)
    {
        bgcolor = vec4(0.0, 0.0, 0.0, 1.0);
    }else{
        bgcolor = vec4(0.5, 0.5, 0.0, 1.0);
    }
    vec4 color = vec4(1.0);
    if(progress < pause) {
        float currentProg = progress / pause;
        float a = 1.0;
        if(getDelta(textureCoordinate) < getDividerSize()) {
            a = 1.0 - currentProg;
        }
        color = mix(bgcolor, getFromColor(textureCoordinate), a);
    }else if(progress < 1.0 - pause)
    {
        if(getDelta(textureCoordinate) < getDividerSize()) {
            color =  bgcolor;
        }else
        {
            vec2 p = textureCoordinate;
            float currentProg = (progress - pause) / (1.0 - pause * 2.0);
            vec2 q = p;
            vec2 rectanglePos = floor(vec2(size) * q);
            
            float r = rand(rectanglePos) - randomness;
            float cp = smoothstep(0.0, 1.0 - r, currentProg);
            
            float rectangleSize = 1.0 / vec2(size).x;
            float delta = rectanglePos.x * rectangleSize;
            float offset = rectangleSize / 2.0 + delta;
            
            p.x = (p.x - offset)/abs(cp - 0.5)*0.5 + offset;
            vec4 a = getFromColor(p);
            vec4 b = getToColor(p);
            
            float s = step(abs(vec2(size).x * (q.x - delta) - 0.5), abs(cp - 0.5));
            color = mix(bgcolor, mix(b, a, step(cp, 0.5)), s);
        }
    }else
    {
        float currentProg = (progress - 1.0 + pause) / pause;
        float a = 1.0;
        if(getDelta(textureCoordinate) < getDividerSize()) {
            a = currentProg;
        }
        color = mix(bgcolor, getToColor(textureCoordinate), a);
    }
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
