shader_type canvas_item;

uniform float blur_width : hint_range(0, 10) = 1.0;

void vertex() {
	VERTEX += (UV * 2.0 - 1.0) * blur_width;
}

void fragment() {
  // get texture
  vec2 uv = UV;

	vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(blur_width * 2.0));

	uv = (uv - texture_pixel_size * blur_width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;

	if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
		COLOR.a = 0.0;
	} else {
		COLOR = texture(TEXTURE, uv);
	}
}
