shader_type spatial;
render_mode unshaded;

uniform vec3 barva_kapalina : source_color = vec3(0,0.77,1);
uniform vec3 barva_bublina : source_color = vec3(0);
uniform float polomer_bublina : hint_range(0.0, 0.1, 0.0025) = float(0.01);
uniform float rychlost_bublina : hint_range(0.0, 1, 0.1) = float(0.15);
uniform float pocet_bublina : hint_range(1, 200, 1) = float(80.0);


float nahoda(float parametr, float mira){
	return fract(sin(parametr) *mira);
}

void fragment(){
	ALBEDO = barva_kapalina;

	for (float i = 0.0; i < 1.0; i += 1.0/(pocet_bublina +1.0)){

		vec2 stred = vec2(UV.x -i, UV.y -1.0 +fract(
			rychlost_bublina *TIME *nahoda(i,10e2) +nahoda(i,10e2)
			));
		float dalka = length(stred);
		dalka = step(polomer_bublina, dalka);

		if (dalka == 0.0){
			ALBEDO = barva_bublina;
		}
	}
}