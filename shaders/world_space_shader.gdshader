shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D checker_tex;
uniform vec4 color : source_color = vec4(1.0);

varying vec3 v_pos_ws;
varying vec3 v_normal_ws;


void vertex() {
    v_pos_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    v_normal_ws = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
}


void fragment() {
    vec3 abs_n = abs(v_normal_ws);
    vec2 uv = vec2(0.0);

    // Single-sample triplanar mapping: select UV projection based on dominant normal axis,
    // avoiding the cost of three samples and blending used in standard triplanar approach.
    if (abs_n.y > abs_n.x && abs_n.y > abs_n.z) {
        // sign() prevents texture mirroring on bottom faces
        uv = vec2(v_pos_ws.x * sign(v_normal_ws.y), v_pos_ws.z);
    } else if (abs_n.x > abs_n.y && abs_n.x > abs_n.z) {
        // Negations correct orientation and prevent upside-down mapping
        uv = vec2(-v_pos_ws.z * sign(v_normal_ws.x), -v_pos_ws.y);
    } else {
        uv = vec2(v_pos_ws.x * sign(v_normal_ws.z), -v_pos_ws.y);
    }

    vec4 tex = texture(checker_tex, uv);

    // Darken color progressively using each texture channel
    vec3 c1 = color.rgb * 0.8;
    vec3 c2 = c1 * 0.75;

    vec3 result = mix(color.rgb, c1, tex.r);
    result = mix(result, c2, tex.g);
    result = mix(result, c2, tex.b);
    result = mix(result, c2, tex.a);

    ALBEDO = result;
}