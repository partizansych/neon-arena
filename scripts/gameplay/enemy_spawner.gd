class_name EnemySpawner extends Node2D

@export var timer: Timer
@export var enemy_scene: PackedScene
@export var distance: float = 400.0
@export var max_enemies: int = 50

var player: PlayerStateReader

func spawn(pos: Vector2) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.player = player
	enemy.global_position = pos
	get_parent().add_child(enemy)

func _get_random_position() -> Vector2:
	var random_angle := randf_range(0.0, TAU)
	var direction := Vector2(cos(random_angle), sin(random_angle))
	return player.get_pos() + direction * distance

func _on_timer_timeout() -> void:
	spawn(_get_random_position())

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
