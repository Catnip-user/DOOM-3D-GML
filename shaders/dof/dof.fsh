varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float focal_distance;
uniform float focal_range;

void main()
{
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    float depth = texture2D(gm_BaseTexture, v_vTexcoord).r;
    float blur_factor = abs(depth - focal_distance) / focal_range;
    blur_factor = clamp(blur_factor, 0.0, 1.0);
    
    vec4 blurred_color = vec4(0.0);
    float total_weight = 0.0;
    
    for (float x = -2.0; x <= 2.0; x += 1.0) {
        for (float y = -2.0; y <= 2.0; y += 1.0) {
            vec2 offset = vec2(x, y) * blur_factor * 0.01;
            blurred_color += texture2D(gm_BaseTexture, v_vTexcoord + offset);
            total_weight += 1.0;
        }
    }
    
    blurred_color /= total_weight;
    gl_FragColor = mix(color, blurred_color, blur_factor);
}