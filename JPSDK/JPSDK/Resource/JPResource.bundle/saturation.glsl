highp float average = (color.r + color.g + color.b) / 3.0;
if (Saturationll > 0.0) {
    color.rgb += (average - color.rgb) * (1.0 - 1.0 / (1.001 - Saturationll));
} else {
    color.rgb += (average - color.rgb) * (-Saturationll);
}
