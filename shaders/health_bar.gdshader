shader_type canvas_item;


uniform float hurt_time = 0.0;
uniform float anim_fin_time = 0.0;
uniform float old_health : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float curr_health : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec4 fgc_low : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 fgc_high : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 bgc : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float health = mix(old_health, curr_health, smoothstep(hurt_time, anim_fin_time, TIME));
	vec4 fgc = mix(fgc_low, fgc_high, health);
	COLOR = mix(fgc, bgc, float(health < UV.x));
	COLOR.a *= clamp(anim_fin_time + 2.0 - TIME, 0.0, 2.0) / 2.0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
