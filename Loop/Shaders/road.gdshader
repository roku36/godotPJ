shader_type canvas_item;
uniform sampler2D gradient_path : source_color;
uniform float ripple_count = 5.0;
uniform float ripple_strength = 0.1;
uniform float speed = 2.0;
uniform float noise_scale = 100.;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    float distance = UV.x;
    float progress = abs(UV.y - 0.5) / 0.5;

    float ripple = sin(((abs(UV.y - 0.5) * 2.0) * ripple_count - TIME * speed) * 3.14159) * ripple_strength;
    progress += ripple;

    float noise = rand(vec2(TIME, UV.y * noise_scale));
    progress += noise;

    float road_alpha = smoothstep(1.0, 0.0, progress);
//    vec4 color = texture(gradient_path, vec2(distance, 0.5));
    vec4 color = texture(gradient_path, vec2(UV.x, abs(UV.y-0.5)*2.));
    COLOR = vec4(color.rgb, road_alpha);
}