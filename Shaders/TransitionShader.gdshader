shader_type canvas_item;

uniform sampler2D noise_r : repeat_enable;
uniform sampler2D noise_g : repeat_enable;
uniform sampler2D noise_b : repeat_enable;


uniform float noise_r_scale;
uniform float noise_g_scale;
uniform float noise_b_scale;


uniform vec2 noise_r_movement;
uniform vec2 noise_g_movement;
uniform vec2 noise_b_movement;

uniform float color_strength;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;



void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	if (COLOR == vec4(0.0, 1.0, 0.0, 1.0)){
		COLOR.r = texture(noise_r,( UV  + TIME * noise_r_movement) * noise_r_scale).r * color_strength;
		COLOR.g = texture(noise_g,( UV  + TIME * noise_g_movement) * noise_g_scale).r * color_strength;
		COLOR.b = texture(noise_b,( UV  + TIME * noise_b_movement) * noise_b_scale).r * color_strength;

		//vec2 base_uv = (distorted_uv(UV) * distortion_strength) * noise_scale;
		
		//float mask = texture(TEXTURE, UV).a;
		//vec4 color = texture(world_texture, (WorldSpace / world_texture_size) + base_uv);
		//COLOR.rgb = color.rgb;
		//color.a = color.a * mask;
		
		//COLOR = texture(world_texture, );
		
	}
		
}






