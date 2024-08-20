shader_type canvas_item;

uniform vec4 col : source_color;
uniform sampler2D bg;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 center = vec2(0.5);
	float dist = 0.75 + 0.25 * sin(TIME + length(UV - center));
	COLOR.rgb = vec3(dist);
	COLOR.rgb = texture(bg, center + dist * (UV - center)).rgb * col.rgb;
	COLOR.a *= col.a / dist;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
