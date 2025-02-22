shader_type canvas_item;

uniform vec3 space_color: source_color = vec3(0.0, 0.0, 0.0);
uniform float grid_parameter: hint_range(1.0, 500.0, 1.0) = 10.0;

uniform float star_size_parameter:hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float star_size_variation:hint_range(0.0, 1.0, 0.01) = 1.0;

uniform vec2 uv_offset = vec2(0.0, 0.0);

uniform float star_brightness_parameters:hint_range(0.0, 1.0, 0.1) = 0.0;

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

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(space_color, 1.0);
	
	vec2 uv = UV*grid_parameter + uv_offset;
	
	vec2 grid_uv = fract(UV*grid_parameter) - 0.5;
	vec2 grid_id = floor(uv);
	
	for(int x = -1; x <= 1; x++){
		for(int y = -1; y <=1; y++){
			vec2 neigbor = vec2(float(x), float(y));
			vec2 random_coord = RandomVec2(grid_id + neigbor) - 0.5;
			vec2 diff = random_coord + neigbor - grid_uv;
			
			float star_size = RandomFloat(grid_id + neigbor)*star_size_variation*star_size_parameter;
			float star_brightness =  RandomFloat(grid_id + neigbor + vec2(34.6, 26.5))*star_brightness_parameters;
			
			
			COLOR.rgb += Star(diff, star_brightness)*star_size;
		}
	}
	
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
