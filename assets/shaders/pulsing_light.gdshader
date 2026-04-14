shader_type canvas_item;

uniform vec2 center = vec2(0.4, 0.3);
uniform float radius = 0;
uniform float edge_softness = 0;
uniform float pulse_speed = 2.0;
uniform float pulse_amount = 0.005;
uniform float glow_size = 0.05;

uniform vec2 viewport_size = vec2(1920.0,1080.0);

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.92);
uniform vec4 glow_color   : source_color = vec4(0.569, 0.043, 0.231, 0.451);

void fragment() {
    float pulse = sin(TIME * pulse_speed) * pulse_amount;
    float r = radius + pulse;

    vec2 uv = SCREEN_UV;
    vec2 delta = uv - center;

    // correzione aspect ratio: mantiene il foro circolare
    float aspect = viewport_size.x / viewport_size.y;
    delta.x *= aspect;

    float d = length(delta);

    float shadow = smoothstep(r, r + edge_softness, d);

    float glow = 1.0 - smoothstep(r, r + glow_size, d);
    glow *= smoothstep(r - edge_softness, r, d);

    vec4 col = vec4(shadow_color.rgb, shadow_color.a * shadow);
    col.rgb += glow_color.rgb * glow * glow_color.a;
    col.a = max(col.a, glow * glow_color.a);

    COLOR = col;
}