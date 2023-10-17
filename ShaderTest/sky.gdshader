shader_type sky;

// Function to replace the macro in the original shader
vec3 R(vec3 p, vec3 a, float r) {
    return mix(a * dot(p, a), p, cos(r)) + sin(r) * cross(p, a);
}

void sky() {
    vec3 O = vec3(0.0);
    vec3 p;
    vec3 d = normalize(vec3((SKY_COORDS.xy - vec2(0.5)) / 1.0, 1.0));

    for (float i = 0.0, g = 0.0, e, s; i < 90.0; i++) {
        p = g * d;
        p.z += TIME * 0.3;
        p = R(p, normalize(vec3(1.0, 2.0, 3.0)), 0.5);
        s = 2.5;
        p = abs(mod(p - 1.0, 2.0) - 1.0) - 1.0;
        for (int j = 0; j < 10; j++) {
            p = 1.0 - abs(p - 1.0);
            s *= e = -1.8 / dot(p, p);
            p = p * e - 0.7;
        }

        g += e = abs(p.z) / s + 0.001;
        O.rgb += 5e-5 * abs(cos(vec3(3.0, 2.0, 1.0) + log(s * 9.0))) / dot(p, p) / e;
    }

    COLOR = O;
}
