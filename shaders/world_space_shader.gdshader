shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D checker_tex;
uniform vec4 color : source_color = vec4(1.0);

// World-space data passed from vertex shader to fragment shader
varying vec3 v_pos_ws;
varying vec3 v_normal_ws;


void vertex() {
    // Transform vertex position and normal into world space.
    // Done in vertex shader for best performance (cheaper than doing it per fragment).
    v_pos_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    v_normal_ws = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
}


void fragment() {
    // Get absolute value of the world normal to determine the dominant axis.
    // This is the core of optimized triplanar texturing.
    vec3 abs_n = abs(v_normal_ws);
    vec2 uv = vec2(0.0);

    // Optimized single-sample triplanar mapping.
    // We select only the dominant axis based on the normal, avoiding the need for
    // three texture samples and blending (standard triplanar approach).
    if (abs_n.y > abs_n.x && abs_n.y > abs_n.z) {
        // Y-axis dominant (top/bottom faces)
        // Multiply X by sign of normal to prevent texture mirroring on bottom faces
        uv = vec2(v_pos_ws.x * sign(v_normal_ws.y), v_pos_ws.z);
    } 
    else if (abs_n.x > abs_n.y && abs_n.x > abs_n.z) {
        // X-axis dominant (side faces)
        // Negations are used to correct texture orientation and prevent upside-down mapping
        uv = vec2(-v_pos_ws.z * sign(v_normal_ws.x), -v_pos_ws.y);
    } 
    else {
        // Z-axis dominant (front/back faces)
        uv = vec2(v_pos_ws.x * sign(v_normal_ws.z), -v_pos_ws.y);
    }

    // Performance-critical: only one texture lookup instead of three.
    vec4 tex = texture(checker_tex, uv);
    
    // Color blending logic (preserved from original implementation)
    vec3 c1 = color.rgb * 0.5;
    vec3 c2 = c1 * 0.5;
    
    vec3 color1 = mix(color.rgb, c1, tex.r);
    vec3 color2 = mix(color1, c2, tex.g);
    vec3 color3 = mix(color2, c2, tex.b);
    vec3 color4 = mix(color3, c2, tex.a);

    ALBEDO = color4;
}