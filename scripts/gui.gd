extends Control

@export
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	Unlocks.unlocked_spell_2.connect(_on_unlocks_unlocked_spell_2)
	Unlocks.unlocked_spell_3_upgrade.connect(_on_unlocks_unlocked_spell_3_upgrade)
	Unlocks.unlocked_spell_1.connect(_on_unlocks_unlocked_spell_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and %TextBox.visible:
		%TextBox.visible = false
		# Deferred because otherwise the player also does stuff for this interact
		player.set.call_deferred(&"stuck_in_interaction", false)
		%Interact.icon = preload("res://textures/touch_controls/button_interact.png")
	if event.is_action_pressed("pause"):
		var toggled = not %"Pause Menu".visible
		get_tree().paused = toggled
		%"Pause Menu".visible = toggled


func _on_player_interaction(area: Area2D):
	if area is TextBoxInteractable:
		%"Audio UI".play()
		%TextBoxText.text = area.displaytext
		player.stuck_in_interaction = true
		%Interact.icon = preload("res://textures/touch_controls/button_interact_confirm.png")
		# Instantly hidden without deferred
		%TextBox.set.call_deferred(&"visible", true)


func _on_unlocks_unlocked_spell_1():
	%"Spell1".visible = true
	%"Spell1".size = Vector2.ONE * 345


func _on_unlocks_unlocked_spell_2():
	%"Spell2".visible = true
	%"Spell2".size = Vector2.ONE * 230


func _on_unlocks_unlocked_spell_3_upgrade():
	%Interact.position -= %Interact.size
	%Interact.size = Vector2.ONE * 230


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
