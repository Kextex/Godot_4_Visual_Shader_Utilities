shader_type spatial;
// render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform bool _invert_x = false;
uniform bool _invert_y = false;

uniform bool _limit_frames = false;
uniform float _max_frames = 0.0;

uniform bool _anim_loop = false;
uniform bool _particle_anim = true;

uniform int _number_of_columns = 3;
uniform int _number_of_rows = 3;
// uniform sampler2D flipbookTex : source_color;

void fLiPBook(vec2 _i_uv, float _playback_rate, float _instan_custom_z, float _time, out vec2 _result_uv) {
	float total_frames = float(_number_of_columns * _number_of_rows);
	float h_frames = float(_number_of_columns);
	float v_frames = float(_number_of_rows);
	float current_frame;

	if (_particle_anim) {
		current_frame = floor(_instan_custom_z * total_frames);
	} else {
		current_frame = floor(_playback_rate * _time * total_frames);
	}

	if (!_limit_frames) {
		if (!_anim_loop) {
			// Clamp the frame within the valid frame range
			current_frame = clamp(current_frame, 0.0, total_frames - 1.0);
		} else {
			// Use modulo to wrap the frame within the range
			current_frame = mod(current_frame, total_frames);
		}
	} else {
		if (!_anim_loop) {
			current_frame = clamp(current_frame, 0.0, _max_frames - 1.0);
		} else {
			current_frame = mod(current_frame, _max_frames);
		}
	}

	if (_invert_x) {
		_i_uv.x = 1.0 - _i_uv.x;
	}
	if (_invert_y) {
		_i_uv.y = 1.0 - _i_uv.y;
	}

	// Scale down the base UV coordinates based on the number of columns and rows
	_i_uv /= vec2(h_frames, v_frames);
	
	// Adjusts the UV coordinates based on the current frame position in the flipbook texture
	_i_uv += vec2(mod(current_frame, h_frames) / h_frames, floor((current_frame + 0.5) / h_frames) / v_frames);

	_result_uv = _i_uv;
}

//  void fragment() {
//  	ALBEDO = textureLod(flipbookTex, fLiPBook(UV, TIME), 0).xyz ;
//  }
