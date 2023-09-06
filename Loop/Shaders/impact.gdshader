shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment(){
	float mask = (1.0 - smoothstep(size-0.1,size, length(UV - center))) * 
	smoothstep(size-thickness-0.1,size-thickness, length(UV - center));
	vec2 disp = normalize(UV - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV - disp);
//	COLOR.rgb = vec3(mask);
	
}