shader_type sky;

uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);

float Star(vec2 uv){
	float star = 0.01/(length(uv));
	float rays = max(0,1.0 - abs((uv.x*uv.y)*1000.0))*star;
	star = rays;
	return pow(star, 3);
}

uniform float depth_plane = 10.0;
uniform float grid_parameter: hint_range(0.0, 1.0, 0.001) = 0.01;
uniform float light_hight: hint_range(1, 10, 1) = 1.0;
uniform float deep_space: hint_range(0.0, 1.0, 0.01) = 0.0;

uniform float seed_random = 0.0;
float RandomFloat(vec2 star_id){
	float r_1 = 457.1*star_id.x;
	float r_2 = 123.1*star_id.y;
	float t = fract(length(star_id)*654.12);
	return t;
}

void sky() {
	COLOR = sky_color;
	
	float draw_deep_space = smoothstep(deep_space, 1.0, abs(EYEDIR.y));
	
	float x_1 = EYEDIR.x/EYEDIR.y*depth_plane + grid_parameter/2.0;
	float z_1 = EYEDIR.z/EYEDIR.y*depth_plane + grid_parameter/2.0;
	
	float a = PI/grid_parameter;
	float b = PI/grid_parameter;
	vec2 node_id = vec2(floor(x_1/grid_parameter), floor(z_1/grid_parameter));
	float node_x_1 = pow(abs(cos((x_1)*a)), light_hight);
	float node_z_1 = pow(abs(cos((z_1)*b)), light_hight);
	vec2 uv = vec2(node_x_1, node_z_1);
	
	//COLOR.rb += uv;
	COLOR += Star(uv)*draw_deep_space*50.0;
	//COLOR = vec3(draw_deep_space);
}
