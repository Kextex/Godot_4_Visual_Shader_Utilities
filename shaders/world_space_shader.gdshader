shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D checker_tex;
uniform vec4 color : source_color = vec4(1.0);

void get_ws_uv(vec3 _vertex, vec3 _normal, mat4 inv_view_mat, out vec2 _final_uv) {
	// Get UV coordinates in world space
	vec3 vertex_ws = (inv_view_mat * vec4(_vertex, 1.0)).xyz;
	vec3 normal_ws = (inv_view_mat * vec4(_normal, 0.0)).xyz;

	vec2 ver_xy2 = vec2(1.0 - vertex_ws.x, vertex_ws.y);
	vec2 xy = mix(vertex_ws.xy, ver_xy2, float(normal_ws.z > 0.0));

	vec2 ver_yz1 = vec2(1.0 - vertex_ws.z, vertex_ws.y);
	vec2 yz = mix(ver_yz1, vertex_ws.zy, float(normal_ws.x > 0.0));

	vec2 ver_xz1 = vec2(1.0 - vertex_ws.x, vertex_ws.z);
	vec2 xz = mix(ver_xz1, vertex_ws.xz, float(normal_ws.y > 0.0));

	vec3 normal_weight_ws = round(abs(normal_ws));

	vec2 xy_yz = mix(xy, yz, normal_weight_ws.x);

	// Perform rotation calculation
	float rotation_deg = 180.0;
	vec2 pivot = vec2(0.5, 0.5);
	vec2 rotated_uv = xy_yz - pivot;
	float rotation_rad = radians(rotation_deg);
	vec2 cos_sin_rot = vec2(cos(rotation_rad), sin(rotation_rad));
	rotated_uv = vec2(
		(rotated_uv.x * cos_sin_rot.x - rotated_uv.y * cos_sin_rot.y),
		(rotated_uv.x * cos_sin_rot.y + rotated_uv.y * cos_sin_rot.x)
	);
	rotated_uv += pivot;
	
	_final_uv = mix(rotated_uv, xz, normal_weight_ws.y);
}


void fragment() {
//	COLOR = color.rgb;
	
	vec2 uv;
	get_ws_uv(VERTEX, NORMAL, INV_VIEW_MATRIX, uv);
	// Texture
	vec4 tex = texture(checker_tex, uv);
	vec3 c1 = color.rgb * 0.5;
	vec3 c2 = c1 * 0.5;
	vec3 color1 = mix(color.rgb, c1.rgb, tex.r);
	vec3 color2 = mix(color1, c2.rgb, tex.g);
	vec3 color3 = mix(color2, c2.rgb, tex.b);
	vec3 color4 = mix(color3, c2.rgb, tex.a);

	ALBEDO = color4.rgb;
}
