shader_type sky;


uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);

uniform float depth_plane: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float star_size_parameter:hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float star_size_variation:hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float star_brightness_parameters:hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float smooth_horizon_parameter:hint_range(0.0, 1.0, 0.01) = 0.1;


float Star(vec2 uv, float brightness){
	float star = 0.01/(length(uv));
	float rays = max(0, 1.0 - abs((uv.x*uv.y)*1000.0))*star;
	star += rays*brightness;
	return pow(star, 3);
}

float RandomFloat(vec2 uv){
	return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 RandomVec2(vec2 uv){
	vec2 seed = fract(uv*244.048);
	seed += dot(seed, seed + vec2(488.34, 206.543));
	float x = fract(sin(dot(seed, vec2(647,78.233))) * 4858.5453123);
	float y = fract(sin(dot(seed, vec2(889,78.233))) * 4858.5453123);
	return vec2(x, y);
}


void sky() {
	
	COLOR = sky_color;
	
	float smooth_horizon = smoothstep(smooth_horizon_parameter, 1.0, abs(EYEDIR.y));
	vec2 plane_coor = (EYEDIR.xz/abs(EYEDIR.y)*depth_plane);
	vec2 separate_plane = fract(plane_coor);
	vec2 uv_plane = fract(plane_coor) - 0.5;
	vec2 uv_id = floor(plane_coor);
	
	//star size
	float star_size = RandomFloat(uv_id)*star_size_variation*star_size_parameter;
	
	//star brightness
	
	
	//position stars
	for(float x = -1.0; x <= 1.0; x++){
		for(float y = -1.0; y <= 1.0; y++){
			vec2 offset = vec2(x, y);
			vec2 star_position_offset = (RandomVec2(uv_id + offset) - 0.5);
			float star_size = RandomFloat(uv_id + offset)*star_size_variation*star_size_parameter;
			float star_brightness =  RandomFloat(uv_id + offset + vec2(34.6, 26.5))*star_brightness_parameters;
			
			float color_parameter = RandomFloat(uv_id + offset + vec2(34.6, 95.5));
			if(color_parameter <= 0.4){
				COLOR += Star(uv_plane + star_position_offset - offset, star_brightness)*star_size*smooth_horizon;
			}
			
			if(color_parameter > 0.4 && color_parameter <= 0.7){
				COLOR.rb += Star(uv_plane + star_position_offset - offset, star_brightness)*star_size*smooth_horizon;
			}
			
			if(color_parameter > 0.7 && color_parameter <= 1.0){
				COLOR.gb += Star(uv_plane + star_position_offset - offset, star_brightness)*star_size*smooth_horizon;
			}
			//if(color_parameter > 0.9 && color_parameter <= 1.0){
				////COLOR.b += 0.01;
				//COLOR.gr += Star(uv_plane + star_position_offset - offset, star_brightness)*star_size*smooth_horizon;
			//}
			
		}
	}
}
