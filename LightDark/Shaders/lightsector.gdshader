shader_type canvas_item;

uniform float radius = 0.5;
uniform sampler2D curve_texture;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv) / radius;

    if (dist > 1.0) {
        COLOR.rgb = vec3(0.0);
    } else {
        float curve_value = texture(curve_texture, vec2(dist, 0.5)).r;
        COLOR = vec4(vec3(curve_value), 1.0);
    }
}
