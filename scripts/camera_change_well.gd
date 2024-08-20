extends Area2D

@export
var cam_in: Camera2D

@export
var cam_out: Camera2D


func _on_body_entered(body: Node2D) -> void:
	cam_in.enabled = true
	cam_out.enabled = false


func _on_body_exited(body: Node2D) -> void:
	cam_in.enabled = false
	cam_out.enabled = true
