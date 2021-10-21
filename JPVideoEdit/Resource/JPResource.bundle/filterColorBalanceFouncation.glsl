uniform sampler2D inputImageTextureMidColor;
uniform sampler2D inputImageTextureColor;
float changeRGBWithValue(float value, float constant, int isMid, int isAdd)
{
    if (isMid == 1)
    {
        vec4 color = texture2D(inputImageTextureMidColor, vec2(constant, value));
        if (isAdd == 1)
        {
            constant = color.r;
        }else
        {
            constant = color.g;
        }
    }else
    {
        vec4 color = texture2D(inputImageTextureColor, vec2(constant, value));
        if (isAdd == 1)
        {
            constant = constant + color.g;
        }else
        {
            constant = constant - color.r;
        }
    }
    return  constant;
}
