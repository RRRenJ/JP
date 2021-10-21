uniform sampler2D inputImageTextureRGB;
const float c = 0.99452189536827329;
const float s = -0.10452846326765346;
const float sqrtThreell = 1.7320508075688772;
const float Saturationll = -0.10;
const highp vec3 colorWeight = (vec3(2.0 * c, -sqrtThreell * s - c, sqrtThreell * s - c) + 1.0) / 3.0;
