uniform sampler2D inputImageTextureRGB;
const float c = 0.98480775301220802;
const float s = -0.17364817766693033;
const float sqrtThreell = 1.7320508075688772;
const float Saturationll = 0.06;
const highp vec3 colorWeight = (vec3(2.0 * c, -sqrtThreell * s - c, sqrtThreell * s - c) + 1.0) / 3.0;
