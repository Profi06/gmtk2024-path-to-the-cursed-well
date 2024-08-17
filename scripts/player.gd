extends CharacterBody2D


const SPEED = 300.0

func _process(delta: float) -> void:
	if velocity.is_equal_approx(Vector2.ZERO):
		%Texture.play(&"standing")
		position = position.round()
	else:
		%Texture.play(&"walking")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration. 
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
		%Texture.flip_h = direction.x <= 0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 20 * SPEED * delta)
	move_and_slide()
