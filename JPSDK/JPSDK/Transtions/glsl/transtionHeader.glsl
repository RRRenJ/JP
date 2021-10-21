precision highp float;

varying vec2 textureCoordinate;
uniform int isY;
uniform sampler2D inputImageTextureforback;
uniform sampler2D inputImageTextureback;
uniform float progress;
uniform int firstIsImage;
uniform int secondIsImage;
uniform float firstImageProgress;
uniform float secondImageProgress;
uniform float ratio;
uniform vec4 videoForframe;
uniform vec4 videoBackframe;
uniform int forRotation;
uniform int backRotation;


vec4 getFromColor(vec2 uv)
{
    vec4 forColor = vec4(0.0);
    if (isY == 1)
    {
        forColor = vec4(0.0, 0.0, 0.0, 1.0);
    }else{
        forColor = vec4(0.5, 0.5, 0.0, 1.0);
    }
    if (uv.x >= videoForframe.x && uv.x <= (videoForframe.x + videoForframe.z) && uv.y >= videoForframe.y && uv.y <= (videoForframe.y + videoForframe.w) ) {
        vec2 position = vec2((uv.x - videoForframe.x) / videoForframe.z, (uv.y - videoForframe.y) / videoForframe.w);
        
        if (forRotation == 1)
        {
            position = vec2(1.0 - position.y, position.x);
        }else if (forRotation == 2)
        {
            position = vec2(position.y,1.0 - position.x);
        }else if (forRotation ==3)
        {
            position = vec2(1.0 - position.x,1.0 - position.y);
            
        }
        if (firstIsImage != 1)
        {
            forColor = texture2D(inputImageTextureforback, position);
        }else{
            float originX = (1.0 - firstImageProgress) / 2.0;
            forColor = texture2D(inputImageTextureforback, vec2(originX +position.x * firstImageProgress, originX + position.y * firstImageProgress));
        }
    }
    return forColor;
}

vec4 getToColor(vec2 uv)
{
    vec4 backColor = vec4(0.0);
    if (isY == 1)
    {
        backColor = vec4(0.0, 0.0, 0.0, 1.0);
    }else{
        backColor = vec4(0.5, 0.5, 0.0, 1.0);
    }
    if (uv.x >= videoBackframe.x && uv.x <= (videoBackframe.x + videoBackframe.z) && uv.y >= videoBackframe.y && uv.y <= (videoBackframe.y + videoBackframe.w) ) {
        vec2 position = vec2((uv.x - videoBackframe.x) / videoBackframe.z, (uv.y - videoBackframe.y) / videoBackframe.w);
        
        if (backRotation == 1)
        {
            position = vec2(1.0 - position.y, position.x);
        }else if (backRotation == 2)
        {
            position = vec2(position.y,1.0 - position.x);
        }else if (backRotation ==3)
        {
            position = vec2(1.0 - position.x,1.0 - position.y);
        }
        
        if (secondIsImage != 1)
        {
            backColor = texture2D(inputImageTextureback, position);
        }else{
            float originX = (1.0 - secondImageProgress) / 2.0;
            backColor = texture2D(inputImageTextureback, vec2(originX +position.x * secondImageProgress, originX + position.y * secondImageProgress));
        }
    }
    return backColor;
}


