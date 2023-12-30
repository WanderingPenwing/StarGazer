shader_type spatial;

uniform float mag = 0;
uniform float temp = 7000;

void fragment() {
	float brightness = max(0, min(1.0, 1.0 - mag/7.0));
	EMISSION = vec3(1, 1, 1) * brightness;
}
