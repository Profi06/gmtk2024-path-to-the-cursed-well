extends Area2D

var enabled := true

func _on_death_timeout() -> void:
	enabled = false
	var tween = create_tween()
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, 0.1)
	tween.tween_callback(queue_free)


func _on_body_entered(body: Node2D) -> void:
	if enabled and body is BaseEnemy:
		body.stun($Death.time_left)
