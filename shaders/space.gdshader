shader_type sky;

uniform vec3 sky_color: source_color = vec3(0.0, 0.0, 0.0);

float Star(vec2 uv){
	float star = 0.01/(length(uv));
	float rays = max(0,1.0 - abs((uv.x*uv.y)*1000.0))*star;
	star = rays;
	return pow(star, 3);
}


uniform float r_c = 5.0;
uniform float h = 10.0;
uniform float N = 1.0;
uniform float hight = 1.0;
uniform sampler2D noise;

void sky() {
	COLOR = sky_color;
	
	float r = abs(h*length(EYEDIR.xz)/EYEDIR.y);
	float x_1 = r*EYEDIR.x;
	float z_1 = r*EYEDIR.z;
	
	float a = N*2.0*3.14/r_c;
	float b = N*2.0*3.14/r_c;
	float grid_x_1 = abs(cos(a*x_1))*hight;
	float grid_z_1 = abs(cos(b*z_1))*hight;
	vec2 uv = vec2(grid_x_1, grid_z_1);
	COLOR += Star(uv);
	
	//if(length(vec2(x_1, z_1)) <= r_c){
		//float a = N*2.0*3.14/r_c;
		//float b = N*2.0*3.14/r_c;
		//float grid_x_1 = abs(cos(a*x_1))*hight;
		//float grid_z_1 = abs(cos(b*z_1))*hight;
		//vec2 uv = vec2(grid_x_1, grid_z_1);
		//COLOR += Star(uv);
	//}
	//if(){
		//
	//}
	//if(abs(x_1) <= l_1){
		//if(abs(z_1) <= l_2){
			//float a = N*2.0*3.14/l_1;
			//float b = N*2.0*3.14/l_2;
			//float grid_x_1 = abs(cos(a*x_1))*hight;
			//float grid_z_1 = abs(cos(b*z_1))*hight;
			//vec2 uv = vec2(grid_x_1, grid_z_1);
			//COLOR += Star(uv);
		//}
	//}
	//float phi_x = acos(EYEDIR.x) - 0.3;
	//float ind_x = (1.0 + sin(phi_x*40.0))*30.0;
	//
	//float phi_y = acos(EYEDIR.y);
	//float ind_y = (1.0 + sin(phi_y*(40.0+10.0)))*30.0;
	//vec2 uv = vec2(ind_x, ind_y);
	//
	//float phi_x_1 = acos(EYEDIR.x) - 1.3;
	//float ind_x_1 = (1.0 + sin(phi_x_1*40.0))*30.0;
	//
	//float phi_y_1 = acos(EYEDIR.y);
	//float ind_y_1 = (1.0 + sin(phi_y_1*(40.0+10.0)))*30.0;
	//vec2 uv_1 = vec2(ind_x_1, ind_y_1);
	//
	//float phi_x_2 = acos(EYEDIR.x) - 2.6;
	//float ind_x_2 = (1.0 + sin(phi_x_2*40.0))*30.0;
	//
	//float phi_y_2 = acos(EYEDIR.y);
	//float ind_y_2 = (1.0 + sin(phi_y_2*(40.0+10.0)))*30.0;
	//vec2 uv_2 = vec2(ind_x_2, ind_y_2);
	//
	//
	//COLOR.rb += Star(uv);
	//COLOR.b += Star(uv_1);
	//COLOR.gb += Star(uv_1);
	//COLOR.rg += uv;
}
