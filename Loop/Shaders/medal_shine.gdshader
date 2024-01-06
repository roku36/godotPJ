shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0);
uniform float shine_speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.01;
uniform bool active = false;
uniform float opacity : hint_range(0.0, 1.0) = 0.2;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void vertex() {
	if (active) {
		VERTEX.y += 3.0 * sin(TIME * 2.0);
	}
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (active) {
		float shine = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x - UV.y + TIME * shine_speed));
		// COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, shine * shine_color.a);
		// add shine
		// COLOR.rgb = mix(2.0 * COLOR.rgb - shine_color.rgb, shine_color.rgb, shine);

		//COLOR = mix(COLOR, shine_color, shine);
		// use overlay blending instead
		if (shine > 0.0)
			COLOR = overlay(COLOR, shine_color);
	} else {
		// if not active, use opacity
		COLOR.a *= opacity;
	}
}

