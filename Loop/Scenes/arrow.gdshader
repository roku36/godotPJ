shader_type canvas_item;
uniform vec4 arrow_col : source_color;
uniform bool is_flipped;

void fragment() {
    float blink_speed = 2.0;  // Adjust this to change the speed of the movement.
    vec2 uv = is_flipped ? vec2(1.0 - UV.x, UV.y) : UV;
    if (uv.y > 0.5) uv.y = 1.0 - uv.y;
    // float speed = 0.2;  // Adjust this to change the speed of the movement.
    float speed = tan(TIME*blink_speed) * 0.03 + TIME * 0.2;
    // float speed = 0.05;
    vec2 pos = uv - vec2(0.5 + speed, 0.5);

    pos.x *= 2.0;  // Stretch the y axis to make a taller shape.

    // Create the chevron shape.
    float chevron = pos.x - pos.y;
    float shape = mod(chevron, 0.5);

    float center = (uv.y + 0.75) / 2.0;

    // fade out from center to left/right
    float col = 1.0 - abs(center - uv.x)*2.5;

    col *= shape * abs(cos(TIME*blink_speed));

    COLOR = vec4(vec3(arrow_col.rgb), col);
    
}
