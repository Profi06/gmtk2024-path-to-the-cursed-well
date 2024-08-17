/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/pixelate

This shader is under CC0 license. Feel free to use, improve and
change this shader according to your needs and consider sharing
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform vec2 amount = vec2(288., 162.);
uniform sampler2D screen : filter_nearest;

void fragment()
{
	vec2 grid_uv = round(SCREEN_UV * amount) / amount;

	vec4 text = texture(screen, grid_uv);

	COLOR = text;
}