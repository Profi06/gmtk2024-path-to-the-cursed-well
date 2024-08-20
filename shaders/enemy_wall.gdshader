shader_type canvas_item;

uniform vec4 col1 : source_color;
uniform vec4 col2 : source_color;
uniform vec4 col3 : source_color;
uniform vec4 col4 : source_color;
uniform sampler2D pattern : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = 0.3 * texture(pattern, UV + vec2(1.0, 0.0) * 0.98 * TIME).r * col1
	+ 0.2 * texture(pattern, UV + vec2(-1.0, 0.0) * 1.02 * TIME).r * col2
	+ 0.28 * texture(pattern, UV + vec2(0.0, 1.0) * 0.98 * TIME).r * col3
	+ 0.22 * texture(pattern, UV + vec2(0.0, -1.0) * 1.02 * TIME).r * col4;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
