shader_type canvas_item;

uniform sampler2D texture_source: repeat_enable;
uniform float strength = 1;
uniform float angle: hint_range(-0.5, 0.5) = 0.025;
uniform vec4 wave = vec4(0.1, 5, 0.2, 0.01);


void fragment() {
	vec2 uv = UV + sin(wave.xy * UV + TIME * wave.z) * wave.w;
	float ray_strength = texture(texture_source, vec2(uv.x + uv.y * angle, 0)).r;
	ray_strength *= ray_strength;
	 
	COLOR.a *= mix(0, ray_strength - (1.0 - UV.y), strength);
}
