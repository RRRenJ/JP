const float reflection = 0.4;
const float perspective = 0.4;
const float depth = 3.0;
const vec2 boundMin = vec2(0.0, 0.0);
const vec2 boundMax = vec2(1.0, 1.0);
int inBounds (vec2 p) {
    if (all(lessThan(boundMin, p)) && all(lessThan(p, boundMax)))
    {
        return 1;
    }else
    {
        return 0;
    }
}

vec2 project (vec2 p) {
    return p * vec2(1.0, -1.2) + vec2(0.0, -0.02);
}

vec4 bgColor (vec2 p, vec2 pto) {
    pto.y = 1.0 - pto.y;
    vec4 black = vec4(0.0);
    if (isY == 1)
    {
        black = vec4(0.0, 0.0, 0.0, 1.0);
    }else{
        black = vec4(0.5, 0.5, 0.0, 1.0);
    }
    vec4 c = black;
    pto = project(pto);
    if (inBounds(pto) == 1) {
        pto.y = 1.0 - pto.y;
        c = mix(black, getToColor(pto), reflection * mix(1.0, 0.0, pto.y));
    }
    return c;
}
void main()
{
    vec2 p = textureCoordinate;
    vec2 pfr = vec2(-1.);
    vec2 pto = vec2(-1.);
    float middleSlit = 2.0 * abs(p.x-0.5) - progress;
    if (middleSlit > 0.0) {
        pfr = p + (p.x > 0.5 ? -1.0 : 1.0) * vec2(0.5*progress, 0.0);
        float d = 1.0/(1.0+perspective*progress*(1.0-middleSlit));
        pfr.y -= d/2.;
        pfr.y *= d;
        pfr.y += d/2.;
    }
    float size = mix(1.0, depth, 1.-progress);
    pto = (p + vec2(-0.5, -0.5)) * vec2(size, size) + vec2(0.5, 0.5);
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
    if (inBounds(pfr) == 1) {
        color = getFromColor(pfr);
    }
    else if (inBounds(pto) == 1) {
        color = getToColor(pto);
    }
    else {
        color = bgColor(p, pto);
    }
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
