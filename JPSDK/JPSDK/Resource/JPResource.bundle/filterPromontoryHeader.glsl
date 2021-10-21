uniform sampler2D inputImageTextureRGB;
const float c = 0.9975640502598242;
const float s = 0.069756473744125302;
const float sqrtThreell = 1.7320508075688772;
const float Saturationll = -0.30;
const highp vec3 colorWeight = (vec3(2.0 * c, -sqrtThreell * s - c, sqrtThreell * s - c) + 1.0) / 3.0;
