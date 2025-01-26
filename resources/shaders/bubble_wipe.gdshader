shader_type canvas_item;

uniform float radius: hint_range(0, 2.2) = 0.5;
uniform vec2 aspect_ratio = vec2(16, 9);

void fragment() {
	vec2 uv = UV;
	uv -= 0.5;
	uv.x *= aspect_ratio.x / aspect_ratio.y;
	float r = length(uv) * 2.0;
	COLOR.a = step(radius, r);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
