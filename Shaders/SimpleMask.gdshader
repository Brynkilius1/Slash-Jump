shader_type canvas_item;

uniform sampler2D world_texture: filter_nearest, repeat_enable;
uniform sampler2D noise_1 : repeat_enable;
uniform sampler2D noise_2 : repeat_enable;

uniform vec2 world_texture_size = vec2(64.0, 64.0);

varying vec2 WorldSpace;

uniform float distortion_strength;
uniform float distortion_speed;
uniform float noise_scale;

vec2 distorted_uv(vec2 uv){
	vec2 noise_uv = uv + TIME * distortion_speed;
	vec2 noise = vec2(texture(noise_1, noise_uv).r, texture(noise_2, noise_uv).r);
	return noise;
}

void vertex() {
	WorldSpace = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	if (COLOR.g == 1.0){
		vec2 base_uv = (distorted_uv(UV) * distortion_strength) * noise_scale;
		
		float mask = texture(TEXTURE, UV).a;
		vec4 color = texture(world_texture, (WorldSpace / world_texture_size) + base_uv);
		COLOR.rgb = color.rgb;
		color.a = color.a * mask;
		
		//COLOR = texture(world_texture, );
		
	}
		
}






