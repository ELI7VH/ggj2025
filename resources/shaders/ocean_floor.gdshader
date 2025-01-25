shader_type canvas_item;

uniform sampler2D base_texture: repeat_enable;
uniform vec2 uv_scale = vec2(4, 1);

uniform float horizontal_skew: hint_range(0, 1) = 0.2;
uniform float vertical_skew: hint_range(1, 2) = 1.5;
uniform sampler2D cell_texture: repeat_enable;

uniform vec4 wave_a = vec4(4, -3, 3.0, 0.01);
uniform vec4 wave_b = vec4(-0.3, 0.6, 1.2, 0.02);


void fragment() {
	vec2 uv = UV;
	uv.x = 0.5 - (uv.x - 0.5) / (1.0 - horizontal_skew * UV.y);
	uv.y = pow(mix(1.0, 2.0, uv.y), 1.0 + vertical_skew) / 2.0;
	
	uv *= uv_scale;
	
	vec4 base_colour = texture(base_texture, uv);
	
	uv += sin(wave_a.xy * uv + TIME * wave_a.z) * wave_a.w;
	uv += sin(wave_b.xy * uv + TIME * wave_b.z) * wave_b.w;
	
	COLOR = base_colour * texture(cell_texture, uv);
}
