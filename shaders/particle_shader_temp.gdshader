// NOTE: Shader automatically converted from Godot Engine 4.1.1.rc1.mono's ParticleProcessMaterial.

shader_type particles;
uniform vec3 direction;
uniform float spread;
uniform float flatness;
uniform float initial_linear_velocity_min;
uniform float initial_angle_min;
uniform float angular_velocity_min;
uniform float orbit_velocity_min;
uniform float linear_accel_min;
uniform float radial_accel_min;
uniform float tangent_accel_min;
uniform float damping_min;
uniform float scale_min;
uniform float hue_variation_min;
uniform float anim_speed_min;
uniform float anim_offset_min;
uniform float initial_linear_velocity_max;
uniform float initial_angle_max;
uniform float angular_velocity_max;
uniform float orbit_velocity_max;
uniform float linear_accel_max;
uniform float radial_accel_max;
uniform float tangent_accel_max;
uniform float damping_max;
uniform float scale_max;
uniform float hue_variation_max;
uniform float anim_speed_max;
uniform float anim_offset_max;
uniform float lifetime_randomness;
uniform vec4 color_value : source_color;
uniform vec3 gravity;


float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

float rand_from_seed_m1_p1(inout uint seed) {
	return rand_from_seed(seed) * 2.0 - 1.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

void start() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	float angle_rand = rand_from_seed(alt_seed);
	float scale_rand = rand_from_seed(alt_seed);
	float hue_rot_rand = rand_from_seed(alt_seed);
	float anim_offset_rand = rand_from_seed(alt_seed);
	float pi = 3.14159;
	float degree_to_rad = pi / 180.0;

	float tex_angle = 1.0;
	float tex_anim_offset = 1.0;
	float spread_rad = spread * degree_to_rad;
	if (RESTART_VELOCITY) {
		float tex_linear_velocity = 1.0;
		{
			float angle1_rad = rand_from_seed_m1_p1(alt_seed) * spread_rad;
			float angle2_rad = rand_from_seed_m1_p1(alt_seed) * spread_rad * (1.0 - flatness);
			vec3 direction_xz = vec3(sin(angle1_rad), 0.0, cos(angle1_rad));
			vec3 direction_yz = vec3(0.0, sin(angle2_rad), cos(angle2_rad));
			direction_yz.z = direction_yz.z / max(0.0001,sqrt(abs(direction_yz.z))); // better uniform distribution
			vec3 spread_direction = vec3(direction_xz.x * direction_yz.z, direction_yz.y, direction_xz.z * direction_yz.z);
			vec3 direction_nrm = length(direction) > 0.0 ? normalize(direction) : vec3(0.0, 0.0, 1.0);
			// rotate spread to direction
			vec3 binormal = cross(vec3(0.0, 1.0, 0.0), direction_nrm);
			if (length(binormal) < 0.0001) {
				// direction is parallel to Y. Choose Z as the binormal.
				binormal = vec3(0.0, 0.0, 1.0);
			}
			binormal = normalize(binormal);
			vec3 normal = cross(binormal, direction_nrm);
			spread_direction = binormal * spread_direction.x + normal * spread_direction.y + direction_nrm * spread_direction.z;
			VELOCITY = spread_direction * mix(initial_linear_velocity_min, initial_linear_velocity_max,rand_from_seed(alt_seed));
		}
	}
	float base_angle = (tex_angle) * mix(initial_angle_min, initial_angle_max, angle_rand);
	CUSTOM.x = base_angle * degree_to_rad;
	CUSTOM.y = 0.0;
	CUSTOM.w = (1.0 - lifetime_randomness * rand_from_seed(alt_seed));
	CUSTOM.z = (tex_anim_offset) * mix(anim_offset_min, anim_offset_max, anim_offset_rand);

	if (RESTART_ROT_SCALE) {
		TRANSFORM[0].xyz = vec3(1.0, 0.0, 0.0);
		TRANSFORM[1].xyz = vec3(0.0, 1.0, 0.0);
		TRANSFORM[2].xyz = vec3(0.0, 0.0, 1.0);
	}

	if (RESTART_POSITION) {
		TRANSFORM[3].xyz = vec3(0.0, 0.0, 0.0);
	if (RESTART_VELOCITY) VELOCITY = (EMISSION_TRANSFORM * vec4(VELOCITY, 0.0)).xyz;
	TRANSFORM = EMISSION_TRANSFORM * TRANSFORM;
	}
}

void process() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	float angle_rand = rand_from_seed(alt_seed);
	float scale_rand = rand_from_seed(alt_seed);
	float hue_rot_rand = rand_from_seed(alt_seed);
	float anim_offset_rand = rand_from_seed(alt_seed);
	float pi = 3.14159;
	float degree_to_rad = pi / 180.0;

	CUSTOM.y += DELTA / LIFETIME;
	float tv = CUSTOM.y / CUSTOM.w;
	float tex_linear_velocity = 1.0;
	float tex_angular_velocity = 1.0;
	float tex_linear_accel = 1.0;
	float tex_radial_accel = 1.0;
	float tex_tangent_accel = 1.0;
	float tex_damping = 1.0;
	float tex_angle = 1.0;
	float tex_anim_speed = 1.0;
	float tex_anim_offset = 1.0;
	vec3 force = gravity;
	vec3 pos = TRANSFORM[3].xyz;
	// apply linear acceleration
	force += length(VELOCITY) > 0.0 ? normalize(VELOCITY) * tex_linear_accel * mix(linear_accel_min, linear_accel_max, rand_from_seed(alt_seed)) : vec3(0.0);
	// apply radial acceleration
	vec3 org = EMISSION_TRANSFORM[3].xyz;
	vec3 diff = pos - org;
	force += length(diff) > 0.0 ? normalize(diff) * tex_radial_accel * mix(radial_accel_min, radial_accel_max, rand_from_seed(alt_seed)) : vec3(0.0);
	// apply tangential acceleration;
	float tangent_accel_val = tex_tangent_accel * mix(tangent_accel_min, tangent_accel_max, rand_from_seed(alt_seed));
	vec3 crossDiff = cross(normalize(diff), normalize(gravity));
	force += length(crossDiff) > 0.0 ? normalize(crossDiff) * tangent_accel_val : vec3(0.0);
	force += ATTRACTOR_FORCE;

	// apply attractor forces
	VELOCITY += force * DELTA;
	
	// orbit velocity
	float dmp = mix(damping_min, damping_max, rand_from_seed(alt_seed));
	if (dmp * tex_damping > 0.0) {
		float v = length(VELOCITY);
		float damp = tex_damping * dmp;
		v -= damp * DELTA;
		if (v < 0.0) {
			VELOCITY = vec3(0.0);
		} else {
			VELOCITY = normalize(VELOCITY) * v;
		}
	}
	float base_angle = (tex_angle) * mix(initial_angle_min, initial_angle_max, angle_rand);
	base_angle += CUSTOM.y * LIFETIME * (tex_angular_velocity) * mix(angular_velocity_min,angular_velocity_max, rand_from_seed(alt_seed));
	CUSTOM.x = base_angle * degree_to_rad;
	CUSTOM.z = (tex_anim_offset) * mix(anim_offset_min, anim_offset_max, rand_from_seed(alt_seed)) + tv * tex_anim_speed * mix(anim_speed_min, anim_speed_max, rand_from_seed(alt_seed));
	vec3 tex_scale = vec3(1.0);
	float tex_hue_variation = 1.0;
	float hue_rot_angle = (tex_hue_variation) * pi * 2.0 * mix(hue_variation_min, hue_variation_max, rand_from_seed(alt_seed));
	float hue_rot_c = cos(hue_rot_angle);
	float hue_rot_s = sin(hue_rot_angle);
	mat4 hue_rot_mat = mat4(vec4(0.299, 0.587, 0.114, 0.0),
			vec4(0.299, 0.587, 0.114, 0.0),
			vec4(0.299, 0.587, 0.114, 0.0),
			vec4(0.000, 0.000, 0.000, 1.0)) +
		mat4(vec4(0.701, -0.587, -0.114, 0.0),
			vec4(-0.299, 0.413, -0.114, 0.0),
			vec4(-0.300, -0.588, 0.886, 0.0),
			vec4(0.000, 0.000, 0.000, 0.0)) * hue_rot_c +
		mat4(vec4(0.168, 0.330, -0.497, 0.0),
			vec4(-0.328, 0.035,  0.292, 0.0),
			vec4(1.250, -1.050, -0.203, 0.0),
			vec4(0.000, 0.000, 0.000, 0.0)) * hue_rot_s;
	COLOR = hue_rot_mat * color_value;

	TRANSFORM[0].xyz = normalize(TRANSFORM[0].xyz);
	TRANSFORM[1].xyz = normalize(TRANSFORM[1].xyz);
	TRANSFORM[2].xyz = normalize(TRANSFORM[2].xyz);
	float base_scale = mix(scale_min, scale_max, scale_rand);
	base_scale = sign(base_scale) * max(abs(base_scale), 0.001);
	TRANSFORM[0].xyz *= base_scale * sign(tex_scale.r) * max(abs(tex_scale.r), 0.001);
	TRANSFORM[1].xyz *= base_scale * sign(tex_scale.g) * max(abs(tex_scale.g), 0.001);
	TRANSFORM[2].xyz *= base_scale * sign(tex_scale.b) * max(abs(tex_scale.b), 0.001);
	if (CUSTOM.y > CUSTOM.w) {
		ACTIVE = false;
	}
}

