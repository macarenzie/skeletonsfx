// Reference: https://blog.maximeheckel.com/posts/the-art-of-dithering-and-retro-shading-web/

shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const int colorStepNum = 10;

const float bias = 0.55f;

#include "BayerMatrix.gdshaderinc"

float random(vec2 c)
{
  return fract(sin(dot(c.xy, vec2(12.9898f, 78.233f))) * 43758.5453f);
}

vec3 posterize(vec3 col, float levels)
{
	col.rgb = col.rgb * (levels - 1.0f);
	col.rgb = floor(col.rgb + 0.5f);
	col.rgb = col.rgb / (levels - 1.0f);
	
	return col;
}

vec3 posterizeHard(vec3 col, float levels)
{
	col.rgb = col.rgb * (levels);
	col.rgb = floor(col.rgb);
	col.rgb = col.rgb / (levels);
	
	return col;
}

vec3 whiteNoiseDither(vec2 uv, vec2 resolution, vec3 color)
{
  	//vec3 color = vec3(lum);
	
	int x = int(uv.x * resolution.x * 0.25f) % 8;

  	int y = int(uv.y * resolution.y * 0.25f) % 8;

  	float threshold = (bayerMatrix8x8[y*8 + x] - bias)*0.4f;
	
	color.rgb += threshold;
  	//color.rgb += -0.25f + random(uv)*0.5f;
	
	color = posterizeHard(color, 20);

  return color;
}

void fragment()
{
	// Called for every pixel the material is visible on.
	vec3 col = texture(screen_texture, SCREEN_UV).xyz;
	
	float lum = dot(vec3(0.2126f, 0.7152f, 0.0722f), col.rgb);
	vec2 resolution = vec2(1.0f/SCREEN_PIXEL_SIZE.x, 1.0f/SCREEN_PIXEL_SIZE.y);
  	COLOR = vec4(whiteNoiseDither(SCREEN_UV, resolution, col), 1);
}
