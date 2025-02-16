shader_type sky;

uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);
uniform float star_height = 5.0;
uniform float hight = 1.0;


float Star(vec2 uv){
	float star = 0.01/(length(uv));
	float rays = max(0,1.0 - abs((uv.x*uv.y)*1000.0))*star;
	star = rays;
	return pow(star, 3);
}

void sky() {
	vec2 uv = fract(EYEDIR.xz*star_height);
	COLOR = sky_color;
	
	COLOR += Star(uv);
	//COLOR.rg = uv;
}
