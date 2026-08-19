extern number time;

vec3 HSVtoRGB(vec3 hsv)
{
    vec3 rgb = clamp(
        abs(mod(hsv.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
        0.0,
        1.0
    );

    rgb = rgb * rgb * (3.0 - 2.0 * rgb);

    return hsv.z * mix(vec3(1.0), rgb, hsv.y);
}

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, uv) * color;

    if (pixel.a <= 0.0)
        return pixel;

    const number cycleDuration = 5.0;

    number hue = mod(time, cycleDuration) / cycleDuration;
    vec3 hsvColor = HSVtoRGB(vec3(hue, 1.0, 1.0));

    const vec3 luminanceWeights = vec3(0.299, 0.587, 0.114);
    number brightness = dot(pixel.rgb, luminanceWeights);

    return vec4(hsvColor * brightness, pixel.a);
}