shader_type canvas_item;

uniform vec2 blobs[100]; // array of blob positions, normalized to [0,1]

void fragment() {
    vec4 color = vec4(0.0);
    for (int i = 0; i < 100; i++) {
        float dist = distance(UV, blobs[i]);
        color += smoothstep(0.1, 0.0, dist);
    }
    COLOR = vec4(color.rgb, 1.0); // assuming blobs are white, replace color.rgb with your color
}
