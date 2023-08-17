// Based on: https://www.shadertoy.com/view/WstXR8
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D bayerTexture;
uniform float gamma1 = 2.2;
uniform float gamma2 = 0.004;
uniform vec4 color1: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color2: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec2 rectPos;

void fragment() {
	vec2 iResolution = 1.0 / (SCREEN_PIXEL_SIZE);
    vec2 uv = FRAGCOORD.xy/iResolution.xy;
    vec4 col = texture(SCREEN_TEXTURE,uv);
    
    // gamma correction
    col = vec4(pow(col.rgb,vec3(gamma1)) - gamma2,col.a);
    
    // find bayer matrix entry based on fragment position
    vec2 bayerUV = mod(FRAGCOORD.xy, 4.0) /4.0;
    float bayerValue = texture(bayerTexture, bayerUV).r + 0.01;
    
    // if bayerValue is 0, use the green, otherwize red
    float dithered = step(bayerValue,col.r);

    vec4 col2 = (dithered <= 0.5) ? color1 : color2;
    COLOR = col2;
}
