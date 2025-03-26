shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const float _PosterizationLevels = 20.0f;

vec3 posterize(vec3 col, float levels)
{
	col = col * (levels - 1.0f);
	col = floor(col + 0.5f);
	col = col / (levels - 1.0f);
	
	return col;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 col = texture(screen_texture, SCREEN_UV).xyz;
	
	col = posterize(col, _PosterizationLevels);
	
	COLOR = vec4(col, 1);
	//COLOR = vec4(1, 1, 1, 1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
