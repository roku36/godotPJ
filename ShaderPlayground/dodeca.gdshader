shader_type canvas_item;

void fragment() {
    float stepSize = 0.0;
    float distance = sqrt(5.) * 0.5 + 0.5;
    vec3 resolution = vec3(SCREEN_PIXEL_SIZE, 1.0);
    vec3 eye = vec3(0.0);
    vec3 normal = vec3(0.0);
    vec3 position = vec3(0.0);
    vec2 fragCoord = FRAGCOORD.xy;
    vec3 rayDir = vec3((fragCoord + fragCoord - resolution.xy) / resolution.y, 1.0);
    vec3 baseColor = 1.0 - vec3(distance, 0.0, 1.0 / distance);
    eye.y = 0.01;

    for (int i = 0; i < 61; i++) {
        normal[i % 3] = distance * 0.3;
        stepSize += normal[i % 3];

        eye = eye.yzx;
        position = rayDir * stepSize + eye;
        position.z -= 4.0;

        float angle = TIME + float(i % 4) * 11.0;
        mat2 rot = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
        
        position.xz *= rot;
        position = abs(position);
        distance -= 1.5;

        for (int j = 0; j < 3; j++) {
            baseColor = baseColor.yzx;
            distance = max(distance, dot(cross(baseColor, baseColor.yzx), 1.0 - position));
        }
    }

    COLOR = vec4(baseColor, 1.0);
    // COLOR = vec4(1.6) - 0.1 * dot(resolution * baseColor, normal);
    COLOR.a = 1.0;
}
