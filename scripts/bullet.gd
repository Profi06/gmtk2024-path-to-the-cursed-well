extends Area2D

var speed := 50.0
var target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var max_dist = 128 ** 2
	var inrange = []
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var enemy_dist = position.distance_squared_to(enemy.position)
		if enemy_dist < max_dist:
			inrange.push_back(enemy.position)
	if inrange.is_empty():
		queue_free()
	else:
		target = inrange.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = position.direction_to(target)
	position += direction * speed * delta
	# Check if moved past target
	if abs(position.direction_to(target).angle_to(direction)) > 0.5 * PI:
		death()

func death():
	if $Texture.animation == "death":
		return
	$Texture.play("death")
	$"Death Collision".disabled = false
	speed = 0


func _on_texture_animation_finished() -> void:
	if $Texture.animation == "death":
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		body.hurt(25)
