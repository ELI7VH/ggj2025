shader_type canvas_item;

uniform float radius: hint_range(0, 2.2) = 0.5;
uniform float outer_radius: hint_range(0, 2.5) = 1.0;
uniform vec2 aspect_ratio = vec2(16, 9);

void fragment() {
	vec2 uv = UV;
	uv -= 0.5;
	uv.x *= aspect_ratio.x / aspect_ratio.y;
	float r = length(uv) * 2.0;
	COLOR.a = step(radius, r) * step(r, outer_radius);
}
