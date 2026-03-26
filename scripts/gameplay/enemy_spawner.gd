class_name EnemySpawner extends Node2D

@export var timer: Timer
@export var enemy_scene: PackedScene
@export var distance: float = 400.0
@export var max_enemies: int = 50

@export var player: Node2D

func spawn(pos: Vector2) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.global_position = pos
	enemy.player_ref = player
	get_tree().current_scene.add_child(enemy)

func _get_random_position() -> Vector2:
	var random_angle := randf_range(0.0, TAU)
	var direction := Vector2(cos(random_angle), sin(random_angle))
	return player.global_position + direction * distance

func _ready() -> void:
	timer.timeout.connect(spawn.bind(_get_random_position()))