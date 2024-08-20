class_name BaseEnemy
extends CharacterBody2D

@export
var speed = 50.0
var curr_speed = speed
@export
var attack_damage = 50
@export
var health = 100
var has_target = false

func _ready() -> void:
	new_target()
	%Healthbar.max = health
	%Healthbar.curr = health


func _process(delta: float) -> void:
	if %Texture.animation == &"walking":
		if velocity.is_equal_approx(Vector2.ZERO):
			%Texture.play(&"standing")
		else:
			%Texture.flip_h = velocity.x < 0
	elif %Texture.animation == &"standing" and not velocity.is_equal_approx(Vector2.ZERO):
		%Texture.play(&"walking")

	if %Attack.has_overlapping_bodies():
		var body = %Attack.get_overlapping_bodies()[0]
		if body is Player:
			body.hurt(attack_damage * delta)


func _physics_process(delta: float) -> void:
	if not %Texture.animation == &"death":
		move_towards_target()
	move_and_slide()


func move_towards_target():
	if not has_target:
		return
	var target: Vector2 = %Nav.get_next_path_position()
	var direction = (target - position).normalized()
	if not %Nav.is_target_reachable():
		stand()
		has_target = false
	elif not %Nav.is_target_reached():
		velocity = curr_speed * direction


func new_target():
	if %Texture.animation == &"death":
		return
	stand()
	if %"Player Finder".has_overlapping_bodies():
		var player = %"Player Finder".get_overlapping_bodies()[0]
		%Nav.target_position = player.position + Vector2(-2 + 4 * randf(), -2 + 4 * randf())
		has_target = true
	else:
		has_target = false


func attack():
	if %"Stun Timer".time_left > 0:
		return
	velocity = Vector2.ZERO
	%Texture.play(&"attack")
	$"Update Target Timer".start()
	


func stand():
	velocity = Vector2.ZERO
	%Texture.play(&"standing")


func stun(time: float):
	if %Texture.animation == &"attack":
		%Texture.play(&"standing")
	curr_speed = 0.0
	if time > %"Stun Timer".time_left:
		%"Stun Timer".start(time)


func hurt(dmg: float):
	%Healthbar.hurt(dmg)


func _on_healthbar_game_over() -> void:
	velocity = Vector2.ZERO
	$"Update Target Timer".stop()
	%Texture.play(&"death")


func _on_update_target_timer_timeout() -> void:
	new_target()


func _on_nav_navigation_finished() -> void:
	attack()


func _on_texture_animation_changed() -> void:
	var sprite_flip = func():
			%AttackRight.disabled = %Texture.animation != &"attack" or %Texture.flip_h
			%AttackLeft.disabled = %Texture.animation != &"attack" or not %Texture.flip_h
	sprite_flip.call_deferred()


func _on_texture_animation_finished() -> void:
	if %Texture.animation == &"death":
		queue_free()


func _on_player_finder_body_entered(body: Node2D) -> void:
	new_target()


func _on_stun_timer_timeout() -> void:
	curr_speed = speed


func _on_texture_frame_changed() -> void:
	if %Texture.animation == &"attack" and %Texture.frame == 2:
		%"Audio Attack".play()
