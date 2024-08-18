class_name Player
extends CharacterBody2D


const SPEED = 100.0
var stuck_in_interaction := false :
	set(val):
		stuck_in_interaction = val
		%"Interaction Range".monitoring = not val

var health := 100.0
var max_health := 100.0

func _process(delta: float) -> void:
	if velocity.is_equal_approx(Vector2.ZERO):
		%Texture.play(&"standing")
	else:
		%Texture.play(&"walking")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration. 
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction and not stuck_in_interaction:
		velocity = direction * SPEED
		%Texture.flip_h = direction.x <= 0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 20 * SPEED * delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and %"Interaction Range".has_overlapping_areas():
		var area = %"Interaction Range".get_overlapping_areas()[0]
		get_tree().call_group(&"PlayerInteractionListeners", &"_on_player_interaction", area)
	elif event.is_action_pressed("interact"):
		hurt(20.0)


func hurt(dmg: float):
	var time = Time.get_ticks_msec() / 1000.0 - 0.5
	%Healthbar.material.set_shader_parameter("hurt_time", time)
	%Healthbar.material.set_shader_parameter("anim_fin_time", time + 0.5)
	%Healthbar.material.set_shader_parameter("old_health", health / max_health)
	health -= dmg
	%Healthbar.material.set_shader_parameter("curr_health", health / max_health)
