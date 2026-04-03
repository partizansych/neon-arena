class_name EnemyInfo
#TODO: я бы лучше назвал EnemyStorage или EnemyInfo

var _positions: PackedVector2Array = []
var _healths: PackedFloat32Array = []

#TODO: сделать кастомные итераторы для них двоих, а пока публичные
var free_stack: PackedInt32Array = []
var active_indices: PackedInt32Array = []

# Двигать к игроку будет класс выше!

func _init(capacity: int) -> void:
	_positions.resize(capacity)
	_healths.resize(capacity)
	free_stack.resize(capacity)

	for i in capacity:
		free_stack[i] = i
		_release(i)

func get_pos(index: int) -> Vector2:
	return _positions[index]

func get_health(index: int) -> float:
	return _healths[index]

func set_pos(index: int, new_pos: Vector2) -> void:
	_positions[index] = new_pos

func spawn(pos: Vector2) -> int:
	var index := free_stack[-1]
	_healths[index] = 100.0
	
	free_stack.remove_at(free_stack.size() - 1)
	active_indices.append(index)
	set_pos(index, pos)
	return index

func kill(index: int) -> void:
	# 1. Удаление из первого мира
	# Убираем из активного списка (O(1) Swap-Remove)
	var active_index := active_indices.find(index)

	if active_index != -1:
		# Меняем местами с последним и удаляем последний
		active_indices[active_index] = active_indices[-1]
		active_indices.remove_at(active_indices.size() - 1)

	free_stack.append(index)
	_release(index)

func damage(index: int, amount: float) -> void:
	_healths[index] -= amount
	if _healths[index] <= 0:
		kill(index)

func _release(index: int) -> void:
	_positions[index] = Vector2(-99999.0, -99999.0)
	_healths[index] = 0.0
