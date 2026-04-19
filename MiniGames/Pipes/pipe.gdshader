shader_type canvas_item;

uniform sampler2D pipe_mask;
uniform float progress : hint_range(0.0, 1.0);
uniform vec2 direction = vec2(1.0, 0.0);

void fragment() {
    vec2 uv = UV;

    vec4 mask_tex = texture(pipe_mask, uv);

    // pipe shape mask (THIS is your key requirement)
    float alpha_mask = mask_tex.a;

    float flow = 0.0;

    // directional fill
    if (abs(direction.x) > 0.5) {
        if (direction.x > 0.0) {
            flow = step(uv.x, progress);
        } else {
            flow = step(1.0 - uv.x, progress);
        }
    } else {
        if (direction.y > 0.0) {
            flow = step(uv.y, progress);
        } else {
            flow = step(1.0 - uv.y, progress);
        }
    }

    float final_mask = flow * alpha_mask;

    vec3 water_color = vec3(0.2, 0.6, 1.0);

    COLOR = vec4(water_color, final_mask);
}