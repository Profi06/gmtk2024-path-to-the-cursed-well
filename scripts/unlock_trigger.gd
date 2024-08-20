class_name UnlockTrigger
extends Area2D

signal unlocked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is Player:
		unlocked.emit()
