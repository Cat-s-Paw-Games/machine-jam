shader_type canvas_item;

uniform vec3 band_color : source_color = vec3(1.0, 1.0, 0.0);
uniform float band_thickness : hint_range(0.02, 0.34, 0.01) = 0.2;
uniform float speed : hint_range(0.14, 1.5, 0.02) = 0.3;
uniform bool reverse = false;

// nuova: angolo della diagonale (in radianti)
uniform float angle = 0.785398; // 45°

void fragment() {
	float r = reverse ? -1.0 : 1.0;
	float progress = fract(TIME * speed * r);

	float band_thickness_half = band_thickness / 2.0;
	float t = mix(-band_thickness, 1.0 + band_thickness_half, progress);
	float band_start = t - band_thickness_half;
	float band_end = t + band_thickness_half;

	// direzione diagonale
	vec2 dir = vec2(cos(angle), sin(angle));

	// proiezione UV sulla direzione
	float t2 = dot(UV, dir);

	if (t2 >= band_start && t2 <= band_end) {
		COLOR.rgb += band_color;
	}
}