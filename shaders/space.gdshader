shader_type sky;

uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 star_color: source_color = vec3(1.0, 0.0, 0.0);
uniform float hight = 1.0;

uniform sampler2D star_map;



float Star(vec2 uv){
	float star = 0.01/(length(uv));
	float rays = max(0,1.0 - abs((uv.x*uv.y)*100.0))*star;
	star = rays;
	return pow(star, 3);
}

//float Star(vec3 coord){
	//float light = 0.001/distance(vec3(1.0, 0.0, 0.0), coord);
	//return light;
//}


void sky() {
	COLOR = sky_color;
	
	COLOR += Star(EYEDIR.xy);
	//SKY_COORDS
}
