class_name TextBoxInteractable
extends Area2D

@export_multiline
var displaytext: String = ""

func _ready() -> void:
	collision_mask = 0x8
