class_name VampireSurvivor extends Node2D

@export var enemy_renderer: MultiMeshInstance2D
@export var player: Player

@export_group("Технические настройки")
@export var cell_size: float = 100
@export var max_enemies: int = 1000
@export var max_projectiles: int = 1000

@export_group("Настройки врагов")
@export var enemy_speed: float = 100.0
@export var enemy_health: float = 100.0
@export var enemy_damage: float = 1.0
@export var separation_radius: float = 20.0
@export var separation_strength: float = 50.0

const EMPTY_POS := Vector2(-99999.0, -99999.0)

var positions: PackedVector2Array = []
var healths: PackedFloat32Array = []

#TODO: сделать кастомные итераторы для них двоих, а пока публичные
var free_stack: PackedInt32Array = []
var active_indices: PackedInt32Array = []

func _ready() -> void:
	enemy_renderer.multimesh.instance_count = max_enemies

	positions.resize(max_enemies)
	healths.resize(max_enemies)
	free_stack.resize(max_enemies)

	for i in max_enemies:
		free_stack[i] = i
		positions[i] = EMPTY_POS

	sync_spawn(Vector2.RIGHT * 100.0)
	sync_spawn(Vector2.RIGHT * -100.0)
	sync_spawn(Vector2.DOWN * 100.0)
	sync_spawn(Vector2.DOWN * -100.0)

func _process(delta: float) -> void:
	for i in active_indices:
		var current_pos := positions[i]

		# 1. Вектор движения к игроку (Seek)
		var p_diff := player.global_position - current_pos
		var p_dist := p_diff.length()
		var seek_velocity := p_diff.normalized() * enemy_speed if p_dist > 0.1 else Vector2.ZERO

		var player_repel_velocity := Vector2.ZERO
		if p_dist < 30.0:
			player_repel_velocity = -p_diff.normalized() * 80.0

		# 2. Вектор отталкивания от соседей (Separation)
		var separation_velocity := Vector2.ZERO
		var n_count := 0
		var neighbors := get_objects_in_radius(current_pos, separation_radius)

		for n_idx in neighbors:
			if n_idx == i:
				continue
			
			var n_pos := positions[n_idx]
			var n_diff := current_pos - n_pos
			var n_dist := n_diff.length()

			if n_dist > 0.01 and n_dist < separation_radius:
				var push := n_diff.normalized() * (1.0 / n_dist)
				separation_velocity += push
				n_count += 1

		if n_count > 0:
			separation_velocity = (separation_velocity / n_count).normalized() * separation_strength
		
		var final_velocity := seek_velocity + separation_velocity + player_repel_velocity
		final_velocity.limit_length(enemy_speed)

		var new_pos := current_pos + final_velocity * delta
		sync_set_pos(i, new_pos)

		# Урон
		if p_dist < 20.0:
			player.take_damage(1.0)

func sync_spawn(pos: Vector2) -> void:
	var index := free_stack[-1]
	free_stack.remove_at(free_stack.size() - 1)
	active_indices.append(index)

	healths[index] = 100.0
	positions[index] = pos

	appear(index, pos)
	grid_update_pos(index, EMPTY_POS, pos)

#TODO: Словарь grid и операции с массивами — дорогие операции.
# Если враг просто сдвинулся на 1 пиксель внутри той же клетки (100x100),
# нет смысла перерегистрировать его в сетке каждый кадр. Это снижает нагрузку на CPU в 10-20 раз.
func sync_set_pos(index: int, new_pos: Vector2) -> void:
	grid_update_pos(index, positions[index], new_pos)
	positions[index] = new_pos
	appear(index, new_pos)

#region RENDER
func appear(index: int, pos: Vector2) -> void:
	var new_transform := Transform2D(0, pos)
	enemy_renderer.multimesh.set_instance_transform_2d(index, new_transform)

func camouflage(index: int) -> void:
	var hide_transform := Transform2D(0, Vector2(-99999, -99999))
	enemy_renderer.multimesh.set_instance_transform_2d(index, hide_transform)
#endregion

#region SPATIAL-PARTITION
var grid: Dictionary[Vector2i, Array]

func get_cell(pos: Vector2) -> Vector2i:
	return (pos / cell_size).floor()

func add_to_cell(index: int, cell: Vector2i) -> void:
	if not grid.has(cell):
		grid[cell] = []
	var list: Array = grid[cell]
	if not list.has(index):
		list.append(index)

func remove_from_cell(index: int, cell: Vector2i) -> void:
	if grid.has(cell):
		var list := grid[cell]
		#TODO Swap-Remove
		list.erase(index)
		if list.is_empty():
			grid.erase(cell)

func grid_update_pos(index: int, old_pos: Vector2, new_pos: Vector2) -> void:
	var new_cell := get_cell(new_pos)
	var old_cell := get_cell(old_pos)

	if old_pos != EMPTY_POS:
		remove_from_cell(index, old_cell)
	add_to_cell(index, new_cell)

## Возвращает список индексов объектов, которые находятся в пределах заданного радиуса от точки.
## Использует пространственную сетку для быстрой отсечки заведомо далеких объектов.
##
## @param pos Позиция в мире (например, координаты пули), от которой измеряем расстояние.
## @param radius Радиус поиска в пикселях.
## @return Array Массив индексов объектов-кандидатов на коллизию.
##
## @warning Возвращает объекты из квадратной области, описывающей круг. 
## Требуется дополнительная точная проверка дистанции после вызова!
func get_objects_in_radius(pos: Vector2, radius: float) -> PackedInt32Array:
	var result: PackedInt32Array = []
	var center_cell := get_cell(pos)

	# Если бы радиус пули был 150 пикселей: 150 / 100 = 1.5 → ceil(1.5) = 2.
	# Значит, нужно проверить 2 кольца клеток вокруг.
	var range_cells := ceili(radius / cell_size)

	for x in range(-range_cells, range_cells + 1):
		for y in range(-range_cells, range_cells + 1):
			var cell := center_cell + Vector2i(x, y)
			# Мы смотрим в словарь: «А есть ли вообще кто-то в клетке (2, 2)?»
			if grid.has(cell):
				result.append_array(grid[cell])

	return result
#endregion
