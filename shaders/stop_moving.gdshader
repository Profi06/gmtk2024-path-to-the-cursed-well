shader_type canvas_item;

uniform vec3 col1 : source_color;
uniform sampler2D bg : filter_nearest, repeat_enable;

void vertex() {
	COLOR.rgb = col1;
}

void fragment() {
	COLOR.a = texture(bg, UV + 0.2 * TIME * vec2(0.2, 1.0)).a;
	vec2 temp = pow(abs(2.0 * UV - vec2(1.0)), vec2(4.0));
	COLOR.a += max(temp.x, temp.y);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
