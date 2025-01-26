shader_type canvas_item;

uniform float green = .99;
uniform float radius = 20.0;

void vertex() {
	VERTEX += vec2(cos(TIME-0.5*VERTEX.y)*4.0, 0.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
