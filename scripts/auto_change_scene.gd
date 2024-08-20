class_name AutoChangeScene
extends Area2D

@export_file("*.tscn")
var new_scene: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collision_layer = 0
	collision_mask = 0x2
	monitorable = false
	monitoring = true

func _on_body_entered(body: Node2D):
	if body is Player:
		get_tree().change_scene_to_file.call_deferred(new_scene)
