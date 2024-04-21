shader_type canvas_item;

uniform sampler2D offset_texture;
uniform sampler2D noise;
uniform vec2 swing_angle_vector;
uniform vec2 swing_hit_pos;
uniform float move_strength;
uniform float image_rotation;

uniform float color_dontrol;
uniform bool uv_mode = false;




vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);
    
    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

void vertex() {
	vec4 texture_col = texture(noise, rotateUV(UV, vec2(0.5), TIME * 0.2));
	//vec4 texture_col = texture(offset_texture, UV);
	VERTEX += swing_angle_vector * texture_col.r * move_strength;
	
	
	float dist_to_swing_angle =  swing_angle_vector.y - swing_angle_vector.x;
	

	vec2 rotated_swing_angle_vector = vec2(swing_angle_vector.y * sign(dist_to_swing_angle), swing_angle_vector.x * -sign(dist_to_swing_angle));

	VERTEX += rotated_swing_angle_vector * abs(texture_col.r - 1.0) * 2.0;
	
	vec2 new_uv = UV * texture_col.x;
	new_uv *= 20.0;
	VERTEX = new_uv;
}

void fragment() {
	vec4 texture_col = texture(offset_texture, rotateUV(UV, vec2(0.5), image_rotation));
	//vec2 new_uv = UV * 0.5 + 0.1;
	//COLOR.r = color_dontrol; //COLOR + texture(offset_texture, rotateUV(UV, vec2(0.5), image_rotation));
	
	//vec4 texture_col = texture(offset_texture, UV);
	//COLOR += texture_col;
	
		// Draws the uv instead of the texture (for debugging)

}


