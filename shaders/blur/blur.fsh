varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float blur_amount;

void main()
{
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(blur_amount, 0.0));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-blur_amount, 0.0));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, blur_amount));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -blur_amount));
    gl_FragColor = color / 5.0;
}