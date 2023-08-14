shader_type canvas_item;

uniform sampler2D subTexture;

void fragment() {
    vec4 texColor = texture(subTexture, UV);
    
    if (texColor.r > 0.8) {
        COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red
    } else {
        COLOR = vec4(1.0, 1.0, 1.0, 1.0); // White
    }
}
