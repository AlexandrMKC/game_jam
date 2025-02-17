shader_type sky;

uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);
uniform float star_height = 5.0;
uniform float hight = 1.0;
uniform sampler2D noise;


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
	//float step_y = 0.1;
	//if(EYEDIR.y)
	//float x = fract(EYEDIR.x*star_height);
	//float y = fract(EYEDIR.y*star_height);
	//vec2 uv = vec2(x,y);
	//COLOR = sky_color;
	
	//
	//float phi_x = acos(EYEDIR.x);
	//float ind_x = 1.0 + sin(phi_x*60.0);
	float phi_x = acos(EYEDIR.x) - 0.3;
	float ind_x = (1.0 + sin(phi_x*40.0))*30.0;
	
	float phi_y = acos(EYEDIR.y);
	float ind_y = (1.0 + sin(phi_y*(40.0+10.0)))*30.0;
	vec2 uv = vec2(ind_x, ind_y);
	
	float phi_x_1 = acos(EYEDIR.x) - 1.3;
	float ind_x_1 = (1.0 + sin(phi_x_1*40.0))*30.0;
	
	float phi_y_1 = acos(EYEDIR.y);
	float ind_y_1 = (1.0 + sin(phi_y_1*(40.0+10.0)))*30.0;
	vec2 uv_1 = vec2(ind_x_1, ind_y_1);
	
	float phi_x_2 = acos(EYEDIR.x) - 2.6;
	float ind_x_2 = (1.0 + sin(phi_x_2*40.0))*30.0;
	
	float phi_y_2 = acos(EYEDIR.y);
	float ind_y_2 = (1.0 + sin(phi_y_2*(40.0+10.0)))*30.0;
	vec2 uv_2 = vec2(ind_x_2, ind_y_2);
	
	
	COLOR.rb += Star(uv);
	COLOR.b += Star(uv_1);
	COLOR.gb += Star(uv_1);
	//COLOR.rg += uv;
}
