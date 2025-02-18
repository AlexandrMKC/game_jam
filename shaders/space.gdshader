shader_type sky;

uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);
uniform float depth_plane = 10.0;
uniform float grid_parameter: hint_range(0.0, 1.0, 0.001) = 0.01;
uniform float star_size: hint_range(0.0, 50.0, 1.0) = 1.0;
uniform float draw_deep_horizon: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float draw_plane_size_random: hint_range(1.0, 1000.0, 1.0) = 1.0;

float Star(vec2 uv, float intensity){
	float star = 0.01/(length(uv));
	float rays = max(0.0, 1.0 - abs((uv.x*uv.y)*1000.0))*star;
	star += rays + intensity;
	return pow(star, 4);
}



uniform float seed_random_1 = 123.0;
uniform float seed_random_2 = 934.0;
vec2 RandomVec2(vec2 id){
	vec2 seed = fract((id) + vec2(123.13, 456.92));
	seed += dot(seed, seed + vec2(143.13, 496.92));
	float x = fract(seed.x*seed_random_1 + 234.56);
	float y = fract(seed.y*seed_random_2 + 192.26);
	return vec2(x, y);
}

void sky() {
	COLOR = sky_color;
	
	float smooth_horizont = smoothstep(draw_deep_horizon, 1.0, abs(EYEDIR.y));
	
	float x_1 = EYEDIR.x/EYEDIR.y*depth_plane + grid_parameter/2.0;
	float z_1 = EYEDIR.z/EYEDIR.y*depth_plane + grid_parameter/2.0;
	
	
	float node_x_1 = abs(cos(x_1*PI/grid_parameter/2.0));
	float node_z_1 = abs(cos(z_1*PI/grid_parameter/2.0));
	vec2 node_id = vec2(floor(x_1/grid_parameter), floor(z_1/grid_parameter))/draw_plane_size_random;
	vec2 nodes_uv = vec2(node_x_1, node_z_1);
	
	
	
	for(float i = -1.0; i <= 1.0; i++){
		for(float j = -1.0; j <= 1.0; j++){
			vec2 offset = vec2(j*grid_parameter, i*grid_parameter);
			vec2 random_vector = RandomVec2(node_id + offset);
			float star_size_variation = random_vector.x*70.0*star_size;
			COLOR += Star(nodes_uv - random_vector - offset, 0.0)*smooth_horizont*star_size_variation;
		}
	}
	//COLOR.rb += uv;
	
	//COLOR.rb += random_vector;
}
