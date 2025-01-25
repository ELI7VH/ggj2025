shader_type canvas_item;

uniform sampler2D base_texture: repeat_enable;
uniform sampler2D height_gradient;
uniform vec2 uv_scale = vec2(5, 2);
uniform vec4 wave_a = vec4(1, 1.5, 5, 0.002);
uniform vec4 wave_b = vec4(0.5, 0.6, 3.7, 0.001);
uniform float scroll_speed = 0.015;


void fragment() {
	//vec2 sampling_coords = world_position * sampling_scale / 400.0;
	//sampling_coords += sin(wave.xy * sampling_coords + TIME * wave.z) * wave.w;
	
	vec2 uv = UV * uv_scale;
	uv += sin(wave_a.xy * uv + TIME * wave_a.z) * wave_a.w;
	uv += sin(wave_b.xy * uv + TIME * wave_b.z) * wave_b.w;
	
	float depth = uv.y / uv_scale.y;
	
	uv.y += scroll_speed * TIME;
	
	vec4 depth_colour = texture(height_gradient, vec2(depth, 0));
	
	COLOR = mix(texture(base_texture, uv), vec4(1), depth) * depth_colour;
	
	//vec4 col = texture(noise_texture, sampling_coords);
	//COLOR = mix(base_colour, base_colour * col, noise_affect);
}
