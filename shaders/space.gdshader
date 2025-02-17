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

float test(float x){
	if(x>0.5){
		return 1.0 - x;
	}
	return x;
}

void sky() {
	float x = fract(EYEDIR.x*5.0);
	float y = fract(EYEDIR.y*5.0);
	vec2 uv = vec2(x,y);
	COLOR = sky_color;
	
	COLOR += Star(uv);
	//COLOR.rg = uv;
}
