shader_type canvas_item;

void fragment(){
    float stepSize = 0.0;
    float distance = sqrt(5.) * 0.5 + 0.5;
    // vec3 resolution = vec3(1.0/SCREEN_PIXEL_SIZE, 0.1234);
    vec3 resolution = vec3(1000.2, 1000.2, 0.1234);
    vec3 eye = vec3(0.0);
    vec3 normal = vec3(0.0);
    vec3 position = vec3(0.0);
    vec3 rayDir = vec3((UV.xy * resolution.xy * 2.0 - resolution.xy) / resolution.y, 1);
    vec3 baseColor = 1.0 - vec3(distance, 0, 1.0 / distance);
    eye.y = 0.01;

    for (int i = 0; i < 61; i++) {
        normal[i % 3] = distance * 0.3;
        stepSize += normal[i % 3];

        eye = eye.yzx;
        position = rayDir * stepSize + eye;
        position.z -= 4.0;
        // position.xz *= mat2(cos(TIME + vec4(0, 11, 33, 0)));
        position.xz *= mat2(vec2(cos(TIME + 0.), cos(TIME + 11.)), vec2(cos(TIME + 33.), cos(TIME + 0.)));
        position = abs(position);
        distance -= 1.5;

        for (int j = 0; j < 3; j++) {
            baseColor = baseColor.yzx;
            distance = max(distance, dot(cross(baseColor, baseColor.yzx), 1.0 - position));
        }
    }

    COLOR = vec4(vec3(0.8 + 0.1 * dot(resolution * baseColor, normal)), 1.0);
}
