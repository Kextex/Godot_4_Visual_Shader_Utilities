// shader_type spatial;
// render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform float speed = 2.5;
uniform vec2 scale = vec2(1.0, 1.0);
uniform float column = 3;
uniform float row = 3;
uniform sampler2D flipbookTex : source_color;

void fLiPBook(vec2 _IUv, float _tIme, out vec4 _rEsult) {
	// Calculate the frame index based on the current time and speed
	float frameIndex = floor(_tIme * speed);

	// Calculate the current row and column of the frame
	float currentRow = floor(frameIndex / column);
	float currentColumn = floor(mod(frameIndex, column));

	// Calculate the frame offset in UV coordinates
	vec2 frameOffset = vec2(currentColumn, currentRow);

	// Scale and position the UV coordinates based on the frame index and scale uniform
	vec2 uv = (_IUv * scale) + frameOffset;

	// Calculate the texture coordinates within the specified row and column
	uv.x = fract(uv.x / column);
	uv.y = fract(uv.y / row);

	// Sample the texture at the calculated UV coordinates
	vec4 textureColor = texture(flipbookTex, uv);
	// return textureColor;
    _rEsult = textureColor;
}

// void fragment() {

// 	ALBEDO = fLiPBook(UV, TIME).xyz;
// }
