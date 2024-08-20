class_name EnemySpawner
extends Node2D

@export
var spawn_range := 16.0
@export
var count := 10
@export
var spawn_scene: PackedScene = preload("res://scenes/enemies/base_enemy.tscn")
@export
var await_unlock: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not await_unlock:
		spawn()
	else:
		await_unlock.connect(&"unlocked", spawn, CONNECT_ONE_SHOT)

func spawn() -> void:
	for c in range(count):
		var spawned = spawn_scene.instantiate()
		get_parent().add_child.call_deferred(spawned)
		var distance = spawn_range * sqrt(randf())
		var angle = TAU * randf()
		spawned.position = position + distance * Vector2(cos(angle), sin(angle))
	queue_free()
