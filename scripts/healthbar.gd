class_name Healthbar
extends Sprite2D

signal game_over

var max: float = 100
var curr: float = 100

func hurt(dmg: float):
	set_current(curr - dmg)

func set_current(new: float):
	var time = Time.get_ticks_msec() / 1000.0 - 0.5
	material.set_shader_parameter("hurt_time", time)
	material.set_shader_parameter("anim_fin_time", time + 0.5)
	material.set_shader_parameter("old_health", curr / max)
	
	var prev = curr
	curr = new
	material.set_shader_parameter("curr_health", curr / max)
	if curr <= 0 and prev > 0:
		game_over.emit()

func set_max(new: float):
	create_tween().tween_property(self, ^"scale", new / 100.0, 0.5)
	
	var time = Time.get_ticks_msec() / 1000.0
	material.set_shader_parameter("hurt_time", time)
	material.set_shader_parameter("anim_fin_time", time + 0.5)
	material.set_shader_parameter("old_health", curr / max)
	
	max = new
	material.set_shader_parameter("curr_health", curr / max)
