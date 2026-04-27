class_name EnemySpawner extends Node2D

@export var enemies_data: Array[EnemyData]
@export var distance: float = 400.0
@export var max_enemies: int = 50

var _player: Node2D
var _enemies_parent: Node

func bind_player(player: Player) -> void:
	_player = player

func bind_enemies_parent(parent: Node) -> void:
	_enemies_parent = parent

func spawn(pos: Vector2) -> void:
	var data = enemies_data.pick_random()
	var enemy: Enemy = data.scene.instantiate()
	enemy.setup(data)
	enemy.set_target(_player)
	enemy.global_position = pos
	_enemies_parent.add_child(enemy)

func _get_random_position() -> Vector2:
	var random_angle := randf_range(0.0, TAU)
	var direction := Vector2(cos(random_angle), sin(random_angle))
	return _player.global_position + direction * distance

func _on_timer_timeout() -> void:
	spawn(_get_random_position())

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
