shader_type canvas_item;

uniform vec4 poly_color: source_color = vec4(1.0);
uniform vec4 flash_color: source_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	/* When using shader on your sprite with texture,
	   uncomment the next line that gets color from the texture
	   and remove the line that set color.*/
	// vec4 color = texture(TEXTURE, UV);
	vec4 color = poly_color; // TO BE REMOVED
	
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;
}
