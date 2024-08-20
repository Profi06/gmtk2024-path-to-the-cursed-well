class_name Player
extends CharacterBody2D


const SPEED = 100.0

# NOTICE: Spell names are opposite to unlock order due to no valid reason
const SPELL_2_SCENE = preload("res://scenes/bullet.tscn")
const SPELL_1_SCENE = preload("res://scenes/stop_moving.tscn")

var stuck_in_interaction := false :
	set(val):
		stuck_in_interaction = val
		%"Interaction Range".monitoring = not val

var health := 100.0
var max_health := 100.0

func _ready() -> void:
	Unlocks.reset()
	Unlocks.unlocked_spell_3_upgrade.connect(_on_unlocks_spell_3_upgrade)

func _process(_delta: float) -> void:
	if velocity.is_equal_approx(Vector2.ZERO):
		if %Texture.animation == &"walking":
			%Texture.play(&"standing")
	elif %Texture.animation == &"standing":
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
	if stuck_in_interaction:
		return
	if event.is_action_pressed("interact"):
		if %"Interaction Range".has_overlapping_areas():
			var area = %"Interaction Range".get_overlapping_areas()[0]
			get_tree().call_group(&"PlayerInteractionListeners", &"_on_player_interaction", area)
		else:
			start_spell_3()
	elif event.is_action_pressed("spell_2") and Unlocks.spell_2:
		start_spell_2()
	elif event.is_action_pressed("spell_1") and Unlocks.spell_1:
		start_spell_1()


func hurt(dmg: float):
	%Healthbar.hurt(dmg)


func _on_texture_animation_finished() -> void:
	if %Texture.animation in [&"spell_1", &"spell_2", &"spell_3"]:
		%Texture.animation = &"standing"
		stuck_in_interaction = false
	elif %Texture.animation == &"death":
		get_tree().create_timer(0.5).timeout.connect(func():
				get_tree().change_scene_to_file.call_deferred("res://scenes/game_over.tscn")
		)


func _on_texture_frame_changed() -> void:
	if %Texture.animation == &"spell_3" and %Texture.frame == 4:
		spell_3()
	if %Texture.animation == &"spell_2" and %Texture.frame == 3:
		spell_2()
	if %Texture.animation == &"spell_1" and %Texture.frame == 5:
		spell_1()

func start_spell_1():
	if %Texture.animation in [&"standing", &"walking"]:
		%Texture.play(&"spell_1")
		stuck_in_interaction = true

func start_spell_2():
	if %Texture.animation in [&"standing", &"walking"]:
		%Texture.play(&"spell_2")
		stuck_in_interaction = true

func start_spell_3():
	if %Texture.animation in [&"standing", &"walking"]:
		%Texture.play(&"spell_3")
		stuck_in_interaction = true

func spell_1():
	%"Audio Spell 1".play()
	var stop_moving = SPELL_1_SCENE.instantiate()
	stop_moving.position = position
	get_parent().add_child(stop_moving)


func spell_2():
	%"Audio Spell 2".play()
	for i in range(4):
		var bullet = SPELL_2_SCENE.instantiate()
		var offset = Vector2(-6, -10) if %Texture.flip_h else Vector2(6, -10) 
		bullet.position = position + offset + Vector2(
				randf_range(-1, 1), randf_range(-1, 1))
		get_parent().add_child(bullet)

func spell_3():
	%"Spell 3".visible = true
	%"Audio Spell 3".play()
	for body in %"Spell 3".get_overlapping_bodies():
		if body is BaseEnemy:
			body.hurt(90)
			body.stun(1.15 if Unlocks.spell_3_upgrade else 0.8)
	var tween = create_tween()
	tween.tween_property(%"Spell 3", ^"modulate", Color(1, 1, 1, 0), 0.7)
	tween.tween_callback(func(): 
		%"Spell 3".visible = false
		%"Spell 3".modulate = Color.WHITE
	)


func _on_healthbar_game_over() -> void:
	%Texture.play("death")
	stuck_in_interaction = true

func _on_unlocks_spell_3_upgrade():
	%"Spell 3".scale *= 2.0
