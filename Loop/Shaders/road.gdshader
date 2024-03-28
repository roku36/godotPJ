shader_type canvas_item;
uniform sampler2D gradient_path : source_color;
uniform sampler2D rough_noise: hint_normal;
uniform float ripple_count = 5.0;
uniform float ripple_strength = 0.1;
uniform float speed = 2.0;
uniform float distortion_strength = 0.4;
uniform vec2 noise_aspect_ratio = vec2(1.0, 0.2);

void fragment() {
    float distance = UV.x;
    float progress = abs(UV.y - 0.5) / 0.5;

    float ripple = sin(((abs(UV.y - 0.5) * 2.0) * ripple_count - TIME * speed) * 3.14159) * ripple_strength;
    progress += ripple;
	
    // scale the UV coordinates according to the aspect ratio
    vec2 scaled_uv = UV * noise_aspect_ratio;
    // sample the normal map
    vec4 normal = texture(rough_noise, scaled_uv);
    // use the red and green channels to distort the UV coordinates
    vec2 distorted_uv = UV + (vec2(normal.r, normal.g)-vec2(.5)) * distortion_strength;

    float distorted_progress = abs(distorted_uv.y - 0.5) / 0.5;
    float distorted_ripple = sin(((abs(distorted_uv.y - 0.5) * 2.0) * ripple_count - TIME * speed) * 3.14159) * ripple_strength;
    distorted_progress += distorted_ripple;

    float road_alpha = smoothstep(1.0, 0.0, distorted_progress);
    vec4 color = texture(gradient_path, vec2(distorted_uv.x, abs(distorted_uv.y-0.5)*2.));

    COLOR = vec4(color.rgb, road_alpha);
}
