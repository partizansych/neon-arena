class_name EnemyManager extends Node

@export var multi_mesh: MultiMeshInstance2D
@export var player: Player

const MAX_ENEMIES = 1000
const ENEMY_SPEED = 100.0
const ENEMY_HP = 100.0
const SEPARATION_RADIUS: float = 20.0 # Дистанция, на которой враги начинают толкаться
const SEPARATION_STRENGTH: float = 50.0 # Сила отталкивания (насколько быстро расталкиваются)

var spatial_grid := SpatialGrid.new(100.0, MAX_ENEMIES)

# Data-Oriented Design 
var positions: PackedVector2Array = []
var healths: PackedFloat32Array = []
var active: PackedByteArray = []

func spawn_enemy(pos: Vector2) -> void:
	for i in MAX_ENEMIES:
		if not active[i]:
			print(active[i])
			active[i] = true
			positions[i] = pos
			healths[i] = ENEMY_HP

			var transform := Transform2D(0, positions[i])
			multi_mesh.multimesh.set_instance_transform_2d(i, transform)

			spatial_grid.update(i, pos)
			return

func damage(index: int, damage: float) -> void:
	if active[index]:
		healths[index] -= damage
		# multi_mesh.multimesh.set_instance_color(index, Color.RED)
		if healths[index] <= 0:
			kill(index)

func kill(index: int) -> void:
	active[index] = false
	healths[index] = 0
	spatial_grid.remove_object(index)
	var hide_transform = Transform2D(0, Vector2(-99999, -99999))
	multi_mesh.multimesh.set_instance_transform(index, hide_transform)
	multi_mesh.multimesh.set_instance_color(index, Color.WHITE)

func _process(delta: float) -> void:
	if player == null:
		return
	
	var player_pos := player.global_position
	for i in MAX_ENEMIES:
		if active[i]:
			# Движение к игроку
			var dir_to_player := positions[i].direction_to(player_pos)
			positions[i] += dir_to_player * ENEMY_SPEED * delta

			# Так как работаю с двумя мирами сразу, нужно обновить и во втором мире
			spatial_grid.update(i, positions[i])
			var transform := Transform2D(0, positions[i])
			multi_mesh.multimesh.set_instance_transform_2d(i, transform)
			
			# Урон игроку
			if positions[i].distance_to(player_pos) < 20.0:
				player.take_damage(1.0)

func _ready() -> void:
	positions.resize(MAX_ENEMIES)
	healths.resize(MAX_ENEMIES)
	active.resize(MAX_ENEMIES)
	positions.resize(MAX_ENEMIES)

	multi_mesh.multimesh.instance_count = MAX_ENEMIES

	for i in MAX_ENEMIES:
		healths[i] = 0
		active[i] = false
		positions[i] = Vector2(-99999, -99999)
	
	spawn_enemy(Vector2.ZERO)
	spawn_enemy(Vector2(1000.0, 0.0))
