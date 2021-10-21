void main()
{
    
    vec2 singleStepOffset = vec2(1080.0, 1080.0);
    vec2 blurCoordinates[15];
    vec2 realltCoord = textureCoordinate.xy;
    if (firstIsImage == 1)
    {
        float originX = (1.0 - firstImageProgress) / 2.0;
        realltCoord = vec2(originX +textureCoordinate.x * firstImageProgress, originX + textureCoordinate.y * firstImageProgress);
    }
    
    blurCoordinates[0] = realltCoord.xy;
    blurCoordinates[1] = realltCoord.xy + singleStepOffset * 1.492347;
    blurCoordinates[2] = realltCoord.xy - singleStepOffset * 1.492347;
    blurCoordinates[3] = realltCoord.xy + singleStepOffset * 3.482150;
    blurCoordinates[4] = realltCoord.xy - singleStepOffset * 3.482150;
    blurCoordinates[5] = realltCoord.xy + singleStepOffset * 5.471968;
    blurCoordinates[6] = realltCoord.xy - singleStepOffset * 5.471968;
    blurCoordinates[7] = realltCoord.xy + singleStepOffset * 7.461809;
    blurCoordinates[8] = realltCoord.xy - singleStepOffset * 7.461809;
    blurCoordinates[9] = realltCoord.xy + singleStepOffset * 9.451682;
    blurCoordinates[10] = realltCoord.xy - singleStepOffset * 9.451682;
    blurCoordinates[11] = realltCoord.xy + singleStepOffset * 11.441595;
    blurCoordinates[12] = realltCoord.xy - singleStepOffset * 11.441595;
    blurCoordinates[13] = realltCoord.xy + singleStepOffset * 13.431555;
    blurCoordinates[14] = realltCoord.xy - singleStepOffset * 13.431555;
    vec4 sum = vec4(0.0);
    sum += getFromColor(blurCoordinates[0]) * 0.058055;
    sum += getFromColor(blurCoordinates[1]) * 0.113199;
    sum += getFromColor(blurCoordinates[2]) * 0.113199;
    sum += getFromColor(blurCoordinates[3]) * 0.102271;
    sum += getFromColor(blurCoordinates[4]) * 0.102271;
    sum += getFromColor(blurCoordinates[5]) * 0.085191;
    sum += getFromColor(blurCoordinates[6]) * 0.085191;
    sum += getFromColor(blurCoordinates[7]) * 0.065427;
    sum += getFromColor(blurCoordinates[8]) * 0.065427;
    sum += getFromColor(blurCoordinates[9]) * 0.046329;
    sum += getFromColor(blurCoordinates[10]) * 0.046329;
    sum += getFromColor(blurCoordinates[11]) * 0.030246;
    sum += getFromColor(blurCoordinates[12]) * 0.030246;
    sum += getFromColor(blurCoordinates[13]) * 0.018206;
    sum += getFromColor(blurCoordinates[14]) * 0.018206;
    sum += getFromColor(blurCoordinates[0] + singleStepOffset * 15.421572) * 0.010104;
    sum += getFromColor(blurCoordinates[0] - singleStepOffset * 15.421572) * 0.010104;
    
    vec4 backColor = getToColor(textureCoordinate);
    vec4 color = mix(sum, backColor, progress);
    if (isY == 1)
    {
        gl_FragColor = vec4(color.r, 0.0, 0.0, 1.0);
    }else{
        gl_FragColor = vec4(color.r, color.g, 0.0, 1.0);
    }
}
