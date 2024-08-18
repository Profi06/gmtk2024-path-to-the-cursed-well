extends CharacterBody2D

@export
var player: Player

const SPEED = 50.0

func _ready() -> void:
	%Nav.target_position = player.position

func _physics_process(delta: float) -> void:
	if not %Nav.is_navigation_finished():
		%Texture.play("walking")
		%Texture.flip_h = velocity.x < 0
	var target: Vector2 = %Nav.get_next_path_position()
	var direction = (target - position).normalized()
	if not %Nav.is_target_reachable():
		new_target.call_deferred()
	if not %Nav.is_target_reached():
		velocity = SPEED * direction
	move_and_slide()

func new_target():
	%Nav.target_position = player.position

func _on_update_target_timer_timeout() -> void:
	new_target()


func _on_nav_navigation_finished() -> void:
	velocity = Vector2.ZERO
	%Texture.play("attack")
	$"Update Target Timer".start()
