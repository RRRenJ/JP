color.rgb = vec3(
                 dot(color.rgb, colorWeight.xyz),
                 dot(color.rgb, colorWeight.zxy),
                 dot(color.rgb, colorWeight.yzx)
                 );
