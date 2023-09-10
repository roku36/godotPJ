shader_type canvas_item;

uniform float width = 0.3;
uniform float gradient_ease = 5.0;
uniform float fill_ratio = 0.8;
uniform vec4 left_col : source_color = vec4(1.0);
uniform vec4 right_col : source_color = vec4(1.0);

/*
	 void fragment() {
	 float fill_angle = fill_ratio * PI * 2.0;
	 vec2 uv = UV * 2.0 - 1.0;
	 if (atan(uv.x, uv.y) + PI < fill_angle) {
	 float inner_width = 1.0 - width;
	 inner_width *= inner_width;
	 float d = uv.x * uv.x + uv.y * uv.y;
	 if (d >= inner_width && d <= 1.0) {
	 float w = abs((1.0 + inner_width) / 2.0 - d) / (1.0 - inner_width);
	 w = 1.0 - pow(w + 0.5, gradient_ease);
	 COLOR = vec4(left_col.rgb, min(1.0, w));
	 } else {
	 COLOR.a = 0.0;
	 }
	 } else {
	 float inner_width = 1.0 - width;
	 inner_width *= inner_width;
	 float d = uv.x * uv.x + uv.y * uv.y;
	 if (d >= inner_width && d <= 1.0) {
	 float w = abs((1.0 + inner_width) / 2.0 - d) / (1.0 - inner_width);
	 w = 1.0 - pow(w + 0.5, gradient_ease);
	 COLOR = vec4(right_col.rgb, min(1.0, w));
	 } else {
	 COLOR.a = 0.0;
	 }
	 }
	 }
 */

void fragment() {
	float fill_angle = fill_ratio * PI * 2.0;
	vec2 uv = UV * 2.0 - 1.0;
	float d = uv.x * uv.x + uv.y * uv.y;
	float inner_width = 1.0 - width;
	float w = abs((1.0 + inner_width) / 2.0 - d) / (1.0 - inner_width);
	inner_width *= inner_width;
	w = 1.0 - pow(w + 0.5, gradient_ease);
	
	// on the ring
	if (d >= inner_width && d <= 1.0) { 
		if (atan(uv.x, uv.y) + PI < fill_angle) {
			COLOR = vec4(left_col.rgb, min(1.0, w));
		} else if (atan(uv.x, uv.y) - PI > fill_angle) {
			COLOR = vec4(right_col.rgb, min(1.0, w));
		}else	{
			COLOR.a = 0.0;
		}
	// not on ring
	} else { 
		COLOR.a = 0.0;
	}
}
