shader_type spatial;
render_mode unshaded;

uniform vec3 barva : source_color;

void fragment(){
	ALBEDO = barva;
	
	for (float i = 0.0; i < 1.1; i += 0.05){
		for (float j = 1.1; j > 0.0; j -= 0.05){ 
		
			vec2 stred = vec2(UV.x -i, UV.y -j);
			float dalka = length(stred);
			dalka = step(0.007 *sin(1.5 *TIME +i *10.0 +j *10.0), dalka);
			
			if (dalka == 0.0){
				ALBEDO = vec3(0);
			}
			else {}
		}
	}
}