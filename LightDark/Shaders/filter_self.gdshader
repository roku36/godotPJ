shader_type canvas_item;
uniform sampler2D bayerTexture;
uniform float gamma1 = 2.2;
uniform float gamma2 = 0.004;
uniform vec4 color1: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color2: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec2 rectPos;

void fragment() {
    // sample the texture
    vec4 col = texture(TEXTURE, UV);
    
    // gamma correction
    col = vec4(pow(col.rgb,vec3(gamma1)) - gamma2,col.a);
    
    // find bayer matrix entry based on fragment position
    vec2 bayerUV = mod(SCREEN_UV, 4.0) / 4.0;
    float bayerValue = texture(bayerTexture, bayerUV).r + 0.01;
    
    // output

    // if bayerValue is 0, use the green, otherwise red
    vec4 dithered = vec4(
            step(bayerValue,col.r),
            step(bayerValue,col.r),
            step(bayerValue,col.r),
            col.a);

    vec4 col2 = (dithered.r <= 0.5) ? color1 : color2;
    COLOR = col2;
}
