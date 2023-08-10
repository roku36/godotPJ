shader_type canvas_item;
uniform sampler2D gradient_path : source_color;
uniform sampler2D rough_noise: hint_normal;
uniform float ripple_count = 5.0;
uniform float ripple_strength = 0.1;
uniform float speed = 2.0;
uniform float distortion_strength = 1.5; // add a new uniform to control the distortion strength

void fragment() {
    float distance = UV.x;
    float progress = abs(UV.y - 0.5) / 0.5;

    float ripple = sin(((abs(UV.y - 0.5) * 2.0) * ripple_count - TIME * speed) * 3.14159) * ripple_strength;
    progress += ripple;
	
    float road_alpha = smoothstep(1.0, 0.0, progress);

    // sample the normal map
    vec4 normal = texture(rough_noise, UV);
    // use the red and green channels to distort the UV coordinates
    vec2 distorted_uv = UV + (vec2(normal.r, normal.g)-vec2(0.5)) * distortion_strength;

    vec4 color = texture(gradient_path, vec2(distorted_uv.x, abs(distorted_uv.y-0.5)*2.));
	 
    COLOR = vec4(color.rgb, road_alpha);
}
