shader_type canvas_item;

const float marks = 12.0;
const float major_marks = 4.0;
// Replacae the below references to source_color with hint_color if you are using a version of Godot before 4.0.
uniform vec4 border_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 centre_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 mark_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 hour_hand_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 minute_hand_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 second_hand_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform bool show_edges = false;
uniform float border_width : hint_range(0.0, 0.5) = 0.1;
uniform float centre_width : hint_range(0.0, 0.5) = 0.1;
uniform float mark_width : hint_range(0.01, 0.1) = 0.02;
uniform float marks_outer : hint_range(0.0, 1.0) = 0.85;
uniform float marks_minor_inner : hint_range(0.0, 1.0) = 0.75;
uniform float marks_major_inner : hint_range(0.0, 1.0) = 0.7;
uniform float hour_hand_length : hint_range(0.0, 1.0) = 0.6;
uniform float hour_hand_width : hint_range(0.001, 0.01) = 0.006;
uniform float minute_hand_length : hint_range(0.0, 1.0) = 0.8;
uniform float minute_hand_width : hint_range(0.001, 0.01) = 0.004;
uniform float second_hand_length : hint_range(0.0, 1.0) = 0.7;
uniform float second_hand_width : hint_range(0.001, 0.01) = 0.002;
uniform int hours : hint_range(1, 12, 1) = 12;
uniform int minutes : hint_range(0, 59, 1) = 0;
uniform int seconds : hint_range(0, 59, 1) = 0;

float greater_than(float x, float y) {
  return max(sign(x - y), 0.0);
}

void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
	float a = 1.0 - (atan(uv.x, uv.y) + 3.141592656) / 6.283185312;
	float l = length(uv);
	float second_hand_angle = float(seconds) * 0.016666666;
	float minute_hand_angle = (float(minutes) + float(seconds) / 60.0) * 0.016666666;
	float hour_hand_angle = mod(float(hours) + float(minutes) / 60.0, 12.0) * 0.08333333;
	
//	Uncomment the following line if you are applying the shader to a TextureRect and using a version of Godot before 4.0.
//	COLOR = texture(TEXTURE,UV);

//	If you do not want to render the scale marks remove the following code block.
	COLOR.rgb = mix(COLOR.rgb, mark_color.rgb, mark_color.a * greater_than(abs(mod(a, 1.0 / marks) * marks * 2.0 - 1.0), 1.0 - (mark_width / 6.283185312 / l) * marks) * (greater_than(marks_outer, l) * greater_than(l, marks_minor_inner)));
	COLOR.rgb = mix(COLOR.rgb, mark_color.rgb, mark_color.a * greater_than(abs(mod(a, 1.0 / major_marks) * major_marks * 2.0 - 1.0), 1.0 - (mark_width / 6.283185312 / l) * major_marks) * (greater_than(marks_minor_inner, l) * greater_than(l, marks_major_inner)));

//	If you do not want to render the hour hand remove the following line.
	COLOR.rgb = mix(COLOR.rgb, hour_hand_color.rgb, hour_hand_color.a * greater_than(hour_hand_length, l) * greater_than(hour_hand_width / l, abs(hour_hand_angle - (a + 1.0 * greater_than(-0.5, a - hour_hand_angle) - 1.0 * greater_than(a - hour_hand_angle, 0.5)))));

//	If you do not want to render the minute hand remove the following line.
	COLOR.rgb = mix(COLOR.rgb, minute_hand_color.rgb, minute_hand_color.a * greater_than(minute_hand_length, l) * greater_than(minute_hand_width / l, abs(minute_hand_angle - (a + 1.0 * greater_than(-0.5, a - minute_hand_angle) - 1.0 * greater_than(a - minute_hand_angle, 0.5)))));

//	If you do not want to render the second hand remove the following line.
	COLOR.rgb = mix(COLOR.rgb, second_hand_color.rgb, second_hand_color.a * greater_than(second_hand_length, l) * greater_than(second_hand_width / l, abs(second_hand_angle - (a + 1.0 * greater_than(-0.5, a - second_hand_angle) - 1.0 * greater_than(a - second_hand_angle, 0.5)))));

//	If you do not want to render the centre remove the following line.
	COLOR.rgb = mix(COLOR.rgb, centre_color.rgb, centre_color.a * greater_than(centre_width, l));

//	If you do not want to render the border remove the following line.
	COLOR.rgb = mix(COLOR.rgb, border_color.rgb, border_color.a * greater_than(l, 1.0 - border_width));

//	If you do not want the edges to be transparent remove the following line of code.
//	If you always want the edges to be transparent replace the following line of code with:
//	COLOR.a *= greater_than(1.0, l);
	COLOR.a *= max(sign(1.0 - l), float(show_edges));
}
