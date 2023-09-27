shader_type canvas_item;

uniform vec2 iMouse;
uniform float ck;
uniform float mk;
uniform vec4 in_col: source_color;
uniform vec4 out_col: source_color;

void fragment() {
    vec2 center = vec2(0.5);
    
    float cDist = distance(center, UV) * ck;
    float mDist = distance(iMouse, UV) * mk;
    float color = cDist * cDist * mDist;
    
    if (color > 1.0) {
        COLOR = vec4(1, 1, 1, 0);
    } else {
        COLOR = mix(in_col, out_col, color);
    }
}
