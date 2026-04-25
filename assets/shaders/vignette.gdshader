shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float radius : hint_range(0.0, 1.0) = 0.75;
uniform float softness : hint_range(0.0, 1.0) = 0.35;
uniform float strength : hint_range(0.0, 1.0) = 0.8;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec4 screen = texture(screen_texture, SCREEN_UV);

	vec2 uv = SCREEN_UV - vec2(0.5);
	float dist = length(uv);

	float mask = smoothstep(radius - softness, radius, dist);
	screen.rgb = mix(screen.rgb, vignette_color.rgb, mask * strength);

	COLOR = screen;
}