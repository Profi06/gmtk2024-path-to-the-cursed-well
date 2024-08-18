extends Control

@export
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		%TextBox.visible = false
		player.stuck_in_interaction = false
		%Interact.icon = preload("res://textures/touch_controls/button_interact.png")

func _on_player_interaction(area: Area2D):
	if area is TextBoxInteractable:
		%TextBoxText.text = area.displaytext
		%TextBox.visible = true
		player.stuck_in_interaction = true
		%Interact.icon = preload("res://textures/touch_controls/button_interact_confirm.png")
