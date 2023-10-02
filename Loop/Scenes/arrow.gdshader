shader_type canvas_item;
uniform vec4 arrow_col : source_color;

void fragment() {
    float blink_speed = 2.0;  // Adjust this to change the speed of the movement.
    // float speed = 0.2;  // Adjust this to change the speed of the movement.
     float speed = tan(TIME*blink_speed) * 0.00001 + 0.1;
    // float speed = 0.05;
    vec2 pos = UV - vec2(0.5 + TIME * speed, 0.5);
    // vec2 pos = UV - vec2(mod(TIME * speed, 1.0), 0.5);

    pos.x *= 2.0;  // Stretch the y axis to make a taller shape.

    // Create the chevron shape.
    float line1 = pos.x - pos.y;
    float line2 = pos.x + pos.y;
    float chevron = max(line1, line2);

    // Threshold the chevron shape to create a solid shape.
    // float shape = step(0.5, chevron);
    float shape = mod(chevron, 0.5);

    // fade out from center to left/right
     float col = 1.0 - 2.0 * abs(UV.x - 0.5);

    col *= shape * abs(cos(TIME*blink_speed));
    

    // Output the color.
    COLOR = vec4(vec3(arrow_col.rgb), col);
}
