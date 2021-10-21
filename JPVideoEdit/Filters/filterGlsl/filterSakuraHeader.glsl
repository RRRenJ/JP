uniform sampler2D inputImageTextureRGB;
const float c = 0.99939082701909576;
const float s = 0.034899496702500969;
const float sqrtThreell = 1.7320508075688772;
const highp vec3 colorWeight = (vec3(2.0 * c, -sqrtThreell * s - c, sqrtThreell * s - c) + 1.0) / 3.0;
