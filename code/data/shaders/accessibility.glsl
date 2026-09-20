extern number contrast;
extern number gamma;

extern bool enableColorblind;
extern mat4 colorMatrix;

vec4 effect( vec4 color, Image texture, vec2 uv, vec2 screen_coords )
{
    vec4 pixel = Texel(texture, uv) * color;

    if (gamma != 1.0)
        pixel.rgb = pow(pixel.rgb, vec3(1.0 / gamma));

    if (contrast != 1.0)
        pixel.rgb = ((pixel.rgb - .5) * contrast) + .5;

    if (enableColorblind)
        pixel.rgb = (colorMatrix * vec4(pixel.rgb, 1.0)).rgb;

    return pixel;
}