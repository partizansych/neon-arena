class_name EnemyStorage
## Объединяет три мира, предоставляя свой API для синхронного управления

var _positions: PackedVector2Array = []
var _healths: PackedFloat32Array = []

var _free_stack: PackedInt32Array = []
var _active_indices: PackedInt32Array = []

var _capacity: int
var _multi_mesh: MultiMesh

var _spatial_grid: SpatialGrid

func _init(capacity: int, multi_mesh: MultiMesh) -> void:
	_capacity = capacity
	_multi_mesh = multi_mesh

	_positions.resize(capacity)
	_healths.resize(capacity)
	_free_stack.resize(capacity)

	for i in capacity:
		_free_stack[i] = i
		_hide_render(i)
	
	multi_mesh.instance_count = capacity
	_spatial_grid = SpatialGrid.new(100.0, capacity)

func set_position(index: int, new_pos: Vector2) -> void:
	_positions[index] = new_pos
	_multi_mesh.set_instance_transform_2d(index, Transform2D(0, new_pos))

func spawn(pos: Vector2) -> void:
	var index := _free_stack[-1]
	_healths[index] = 100.0

	_free_stack.remove_at(_free_stack.size() - 1)
	_active_indices.append(index)
	set_position(index, pos)

func kill(index: int) -> void:
	_healths[index] = 0.0
	
	# 1. Удаление из первого мира
	# Убираем из активного списка (O(1) Swap-Remove)
	var index_in_active := _active_indices.find(index)
	if index_in_active != -1:
		# Меняем местами с последним и удаляем последний
		_active_indices[index_in_active] = _active_indices[-1]
		_active_indices.remove_at(_active_indices.size() - 1)
	_free_stack.append(index)

	# 2. Удаление из второго мира
	_spatial_grid.remove_object(index)

	# 3. Удаление из третьего мира
	_hide_render(index)

func damage(index: int, amount: float) -> void:
	_healths[index] -= amount
	if _healths[index] <= 0:
		kill(index)

func _hide_render(index: int) -> void:
	var hide_transform := Transform2D(0, Vector2(-99999, -99999))
	_multi_mesh.set_instance_transform_2d(index, hide_transform)