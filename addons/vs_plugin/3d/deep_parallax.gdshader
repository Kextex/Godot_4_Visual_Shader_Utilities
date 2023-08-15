/*
*	References:
*		https://github.com/Maujoe/Godot-Visual-Shader-Node-Library/blob/master/addons/visual_shader_node_library/shader_nodes/3d/deep_parallax.shader
*/

shader_type spatial;
// uniform sampler2D texture_parallax_default: hint_default_black;
uniform float depth_scalar: hint_range(0.0, 1.0, 0.01) = 0.1;
//uniform sampler2D texture_albedo: source_color;

// Calculate the adjusted depth for a given layer
float calculate_adjusted_depth(float current_layer, float layer_depth) {
    return current_layer * layer_depth;
}

// Sample depth and calculate texture offset for parallax effect
vec2 sample_depth_and_calculate_offset(vec2 uv, sampler2D _depth_texture, float current_depth, vec2 delta, float layer_depth) {
    vec2 ofs = uv;
    float adjusted_depth = current_depth;

    // Iterate twice to sample depth and calculate offset
    for (int i = 0; i < 2; i++) {
        ofs -= 0.2 * delta; // Adjust the texture coordinate
        adjusted_depth = 1.0 - textureLod(_depth_texture, ofs, 0.0).r;
    }

    // Calculate final offset based on adjusted depth
    ofs += (adjusted_depth - current_depth) * delta / layer_depth;

    // Apply step function to control texture blending
    return mix(uv, ofs, step(adjusted_depth, current_depth));
}

// Perform deep parallax mapping
void deep_parallax(in vec2 _uv_in, in sampler2D _depth_texture, in float depth_scale, in float _base_layers, in float _detail_layers, in vec3 vertex, in vec3 normal, in vec3 tangent, in vec3 binormal, in vec3 depth_flip, out vec2 uv_out) {
    vec3 view_dir = normalize(normalize(-vertex) * mat3(tangent * depth_flip.x, -binormal * depth_flip.y, normal));

    // Calculate the number of layers based on view direction
    float num_layers = mix(_detail_layers, _base_layers, abs(dot(vec3(0.0, 0.0, 1.0), view_dir)));
    float layer_depth = 1.0 / num_layers;

    // Calculate the scaled view direction for parallax offset
    vec2 scaled_view_dir = view_dir.xy * depth_scale;
    vec2 delta = scaled_view_dir / num_layers;
    vec2 ofs = _uv_in;

    // Sample initial depth
    float current_depth = 1.0 - textureLod(_depth_texture, ofs, 0.0).r;
    
    bool early_termination = false; // Flag to break out of loop

    // Iterate through layers to perform parallax effect
    for (float current_layer = 0.0; current_layer < num_layers && !early_termination; current_layer += 1.0) {
        float adjusted_depth = calculate_adjusted_depth(current_layer, layer_depth);

        if (adjusted_depth > current_depth) {
            // Calculate texture offset and blending factor
            float lerp_factor = smoothstep(0.0, 1.0, (adjusted_depth - current_depth) / layer_depth);

            ofs = sample_depth_and_calculate_offset(ofs, _depth_texture, current_depth, delta, layer_depth);
            early_termination = true;  // Set the flag to break out of the loop

        } else {
            ofs -= delta; // Adjust texture coordinate
            current_depth = 1.0 - textureLod(_depth_texture, ofs, 0.0).r;
        }
    }

    uv_out.xy = ofs;
}
//
//void fragment() {
    //vec2 corrected_uv;
    //deep_parallax(UV, texture_parallax_default, depth_scalar, 64.0, 128.0, VERTEX, NORMAL, TANGENT, BINORMAL, vec3(1.0, 1.0, 1.0), corrected_uv);
    //ALBEDO = texture(texture_albedo, corrected_uv.rg).rgb;
//}