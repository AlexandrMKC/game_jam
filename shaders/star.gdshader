shader_type spatial;

uniform float number_cell:hint_range(1.0, 1000.0, 1.0) = 100.0;

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
	ALBEDO = vec3(0.);
	EMISSION = vec3(0.);
	vec2 uv = vec2(UV.x*number_cell, UV.y*number_cell);
	vec2 cell_coord = fract(uv);
	vec2 cell_id = floor(uv);
	
	vec2 random_point = RandomVec2(cell_id);
	
	float dist_min = 1.0;
	
	for(int x = -1; x <= 1; x++){
		for(int y = -1; y <= 1; y++){
			vec2 neighbor = vec2(float(x),float(y));
			vec2 random_point = RandomVec2(cell_id + neighbor);
			vec2 diff = cell_coord - (neighbor + random_point);
			float dist = length(diff);
			//ALBEDO += dist*0.1;
			//float min_dist = min(dist_min, dist);
			EMISSION.rg += dist*0.04;
			EMISSION.r += dist*0.06;
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
