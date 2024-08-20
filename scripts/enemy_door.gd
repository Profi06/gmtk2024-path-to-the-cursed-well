extends Node2D

signal unlocked

@export
var enemy_target_count := 0
@export
var stay_locked := false
@export
var await_unlock: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if await_unlock:
		stay_locked = true
		await_unlock.connect(&"unlocked", disable_stay_locked, CONNECT_ONE_SHOT)

func unlock_check():
	var unlock = get_tree().get_node_count_in_group("Enemies") <= enemy_target_count and not stay_locked
	visible = not unlock
	$Collision.disabled = unlock
	if unlock:
		unlocked.emit()

func disable_stay_locked():
	stay_locked = false
	unlock_check()

func _on_check_timer_timeout() -> void:
	unlock_check()
