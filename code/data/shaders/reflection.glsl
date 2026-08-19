extern Image reflectionTexture;

extern vec2 canvasSize;
extern vec2 elementCenter;
extern vec2 elementSize;
extern number elementRotation;

vec4 effect(
    vec4 color,
    Image texture,
    vec2 uv,
    vec2 screen_coords
)
{
    vec4 spritePixel = Texel(texture, uv) * color;
    vec2 localPos = screen_coords - elementCenter;

    number cosine = cos(-elementRotation);
    number sine = sin(-elementRotation);

    vec2 rotatedPos = vec2(
        localPos.x * cosine - localPos.y * sine,
        localPos.x * sine + localPos.y * cosine
    );

    number halfWidth = elementSize.x * 0.5;
    number halfHeight = elementSize.y * 0.5;

    bool insideReflection =
        abs(rotatedPos.x) <= halfWidth &&
        abs(rotatedPos.y) <= halfHeight;

    if (!insideReflection)
    {
        return spritePixel;
    }

    vec2 reflectionUV = screen_coords / canvasSize;

    vec4 reflectionPixel = Texel(
        reflectionTexture,
        reflectionUV
    );

    vec4 reflection = vec4(
        reflectionPixel.rgb,
        1.0
    );

    vec3 resultRGB = mix(
        reflection.rgb,
        spritePixel.rgb,
        spritePixel.a
    );

    return vec4(
        resultRGB,
        1.0
    );
}