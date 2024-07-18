shader_type spatial;

uniform sampler2D noise;

void vertex() {
	float posunuti = texture(noise, UV).x;
	VERTEX = VERTEX +posunuti *NORMAL;
}