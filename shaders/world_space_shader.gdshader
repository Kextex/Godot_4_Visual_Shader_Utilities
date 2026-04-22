shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D checker_tex;
uniform vec4 color : source_color = vec4(1.0);

uniform float c1_contrast : hint_range(0.0, 1.0) = 0.8;
uniform float c2_contrast : hint_range(0.0, 1.0) = 0.75;

varying vec3 v_pos_ws;
varying vec3 v_normal_ws;


void vertex() {
    v_pos_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    v_normal_ws = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}


void fragment() {
    vec3 abs_n = abs(v_normal_ws);
    vec2 uv = vec2(0.0);

    // Single-sample triplanar mapping: choose dominant axis to avoid three texture samples
    if (abs_n.y > abs_n.x && abs_n.y > abs_n.z) {
        uv = vec2(v_pos_ws.x * sign(v_normal_ws.y), v_pos_ws.z);           // prevent mirroring on bottom faces
    } else if (abs_n.x > abs_n.y && abs_n.x > abs_n.z) {
        uv = vec2(-v_pos_ws.z * sign(v_normal_ws.x), -v_pos_ws.y);         // correct orientation
    } else {
        uv = vec2(v_pos_ws.x * sign(v_normal_ws.z), -v_pos_ws.y);
    }

    vec4 tex = texture(checker_tex, uv);

    // Apply contrast variation per channel (R = strong, G/B/A = stronger)
    float intensity_c1 = c1_contrast;
    float intensity_c2 = intensity_c1 * c2_contrast;

    float multiplier = mix(1.0, intensity_c1, tex.r);
    multiplier = mix(multiplier, intensity_c2, tex.g);
    multiplier = mix(multiplier, intensity_c2, tex.b);
    multiplier = mix(multiplier, intensity_c2, tex.a);

    ALBEDO = color.rgb * multiplier;
}