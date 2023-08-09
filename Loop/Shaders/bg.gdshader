shader_type canvas_item;
//Origin code from https://www.shadertoy.com/view/MdlXz8
//Ported by haruyou27

uniform int iteration_times = 3;
uniform float speed = 0.1;
uniform vec4 fg_color : source_color = vec4(1.0, .35, 0.0, 1.0);
uniform vec4 bg_color : source_color = vec4(0.0, .35, 0.5, 1.0);
uniform float intensity = .005;

void fragment() 
{
	vec2 p = mod(UV*TAU, TAU)-250.0;
	vec2 i = vec2(p);
	float c = 1.0;
	float t = TIME * speed;

	for (int n = 0; n < iteration_times; n++) 
	{
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0/length(vec2(p.x / (sin(i.x+t)/intensity),p.y / (cos(i.y+t)/intensity)));
	}
	c /= float(iteration_times);
	c = 1.17-pow(c, 1.4);
	vec4 color = vec4(pow(abs(c), 8.0));
	color *= fg_color;
    color = clamp(color + bg_color, 0.0, 1.0);
    
	COLOR = color;
}
