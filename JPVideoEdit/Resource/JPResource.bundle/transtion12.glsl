#define POW2(X) X*X
#define POW3(X) X*X*X
const float PI = 3.14159265358979323;
const int endx = 2;
const int endy = -1;
float Rand(vec2 v) {
    return fract(sin(dot(v.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec2 Rotate(vec2 v, float a) {
    mat2 rm = mat2(cos(a), -sin(a),
                   sin(a), cos(a));
    return rm*v;
}
float CosInterpolation(float x) {
    return -cos(x*PI)/2.+.5;
}
void main()
{
    vec2 uv = textureCoordinate;
    vec4 color = vec4(0.0);
    vec2 p = uv.xy / vec2(1.0).xy - .5;
    vec2 rp = p;
    float rpr = (progress*2.-1.);
    float z = -(rpr*rpr*2.) + 3.;
    float az = abs(z);
    rp *= az;
    rp += mix(vec2(.5, .5), vec2(float(endx) + .5, float(endy) + .5), POW2(CosInterpolation(progress)));
    vec2 mrp = mod(rp, 1.);
    vec2 crp = rp;
    int onEnd = 0;
    if (int(floor(crp.x)) == endx && int(floor(crp.y)) == endy)
    {
        onEnd = 1;
    }
    if(onEnd == 1) {
        float ang = float(int(Rand(floor(crp))*4.))*.5*PI;
        mrp = vec2(.5) + Rotate(mrp-vec2(.5), ang);
    }
    if(onEnd == 1 || Rand(floor(crp))>.5) {
        color = getToColor(mrp);
    } else {
        color = getFromColor(mrp);
    }
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
