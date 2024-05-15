shader_type canvas_item;

uniform vec4 key_color : source_color = vec4(0,1,0,1);
uniform float similarity : hint_range(0.0,1.0) = 0.4;
uniform float smoothness : hint_range(0.00,1.0) = 0.08;
uniform float spill : hint_range(0.0,1.0) = 0.1;
uniform sampler2D world_texture : repeat_enable;
uniform vec2 world_texture_size = vec2(64.0, 64.0);

varying vec2 WorldSpace;

// From https://github.com/libretro/glsl-shaders/blob/master/nnedi3/shaders/rgb-to-yuv.glsl
vec2 RGBtoUV(vec3 rgb) {
  return vec2(
    rgb.r * -0.169 + rgb.g * -0.331 + rgb.b *  0.5    + 0.5,
    rgb.r *  0.5   + rgb.g * -0.419 + rgb.b * -0.081  + 0.5
  );
}

vec4 ProcessChromaKey(sampler2D tex,vec2 texCoord) {
  vec4 rgba = texture(tex, texCoord);
  float chromaDist = distance(RGBtoUV(texture(tex, texCoord).rgb), RGBtoUV(key_color.rgb));

  float baseMask = chromaDist - similarity;
  float fullMask = pow(clamp(baseMask / smoothness, 0., 1.), 1.5);
	rgba.a = fullMask;  

  float mask = texture(tex, texCoord).a;
	vec4 color = texture(world_texture, WorldSpace / world_texture_size);
	rgba.rgb = color.rgb;
	rgba.a = color.a * mask;

  float spillVal = pow(clamp(baseMask / spill, 0., 1.), 1.5);
  float desat = clamp(rgba.r * 0.2126 + rgba.g * 0.7152 + rgba.b * 0.0722, 0., 1.);
  rgba.rgb = mix(vec3(desat, desat, desat), rgba.rgb, spillVal);

  return rgba;
}




void vertex() {
	WorldSpace = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	
	float mask = texture(TEXTURE, UV).a;
	vec4 color = texture(world_texture, WorldSpace / world_texture_size);
	COLOR = ProcessChromaKey(TEXTURE, UV);
	//COLOR.rgb = color.rgb;
	//color.a = color.a * mask;
}