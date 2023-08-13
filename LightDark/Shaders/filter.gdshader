// Based on: https://www.shadertoy.com/view/WstXR8
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D bayerTexture;
uniform float gamma1 = 2.2;
uniform float gamma2 = 0.004;

void fragment() {
	 // sample the texture
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	// vec2 iResolution = vec2(200, 150);
    vec2 uv = FRAGCOORD.xy/iResolution.xy;
    vec4 col = texture(SCREEN_TEXTURE,uv);
    
    // gamma correction
    col = vec4(pow(col.rgb,vec3(gamma1)) - gamma2,col.a);
    
    // find bayer matrix entry based on fragment position
    // float bayerValue = bayerIndex[int(FRAGCOORD.x) % 4][int(FRAGCOORD.y) % 4];
    vec2 bayerUV = mod(FRAGCOORD.xy, 4.0) / 4.0;
    float bayerValue = texture(bayerTexture, bayerUV).r + 0.01;
    
        // output
    vec4 dithered = vec4(
            step(bayerValue,col.r),
            step(bayerValue,col.g),
            step(bayerValue,col.b),
            col.a);

    COLOR.rgb = dithered.rgb * 0.5 + vec3(0.2);
}
