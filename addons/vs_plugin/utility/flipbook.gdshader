shader_type spatial;
// render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform bool _invertX = false;
uniform bool _invertY = false;

uniform bool _limitFrames = false;
uniform float _maxFrames = 0.0;

uniform float _numColumns = 3.0;
uniform float _numRows = 3.0;
// uniform sampler2D flipbookTex : source_color;

void fLiPBook(vec2 _IUv, float _pLaybackRate, float _tIme, out vec2 _rEsultuv) {
	// Calculate the frame index based on the current time and speed
	float frameIndex;
	if (!_limitFrames) {
		frameIndex = floor(_tIme * _pLaybackRate);
	}
	else {
		frameIndex = floor(mod(_tIme * _pLaybackRate, _maxFrames));
	}

	// Calculate the current row and column of the frame
	float currentRow = floor(frameIndex / _numColumns);
	float currentColumn = floor(mod(frameIndex, _numColumns));

	// Calculate the frame offset in UV coordinates
	vec2 frameOffset = vec2(currentColumn, currentRow);

	// Position the UV coordinates based on the frame index
	vec2 uv = _IUv + frameOffset;

	// Calculate the texture coordinates within the specified row and column
	uv.x = fract(uv.x / _numColumns);
	uv.y = fract(uv.y / _numRows);

	// Apply inversion if enabled
	if (_invertX) {
		uv.x = 1.0 - uv.x;
	}
	if (_invertY) {
		uv.y = 1.0 - uv.y;
	}

   _rEsultuv = uv;
}

//  void fragment() {
//  	ALBEDO = textureLod(flipbookTex, fLiPBook(UV, TIME), 0).xyz ;
//  }
