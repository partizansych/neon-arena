class_name SpatialGrid

const EMPTY_CELL = Vector2i(-99999, -99999)

var _cell_size: float
var _grid: Dictionary[Vector2i, Array]
var _object_cells: Array[Vector2i] = []

func _init(_cell_size: float, max_objects: int) -> void:
	_cell_size = _cell_size
	_object_cells.resize(max_objects)
	for i in max_objects:
		_object_cells[i] = EMPTY_CELL

func get_cell(pos: Vector2) -> Vector2i:
	return (pos / _cell_size).floor()

func add(index: int, cell: Vector2i) -> void:
	if not _grid.has(cell):
		_grid[cell] = []
	var list: Array = _grid[cell]
	if not list.has(index):
		list.append(index)

func remove(index: int, cell: Vector2i) -> void:
	if _grid.has(cell):
		var list = _grid[cell]
		list.erase(index)
		if list.is_empty():
			_grid.erase(cell)

## Обновление позиции объекта
func update(index: int, new_pos: Vector2) -> void:
	var new_cell := get_cell(new_pos)
	var old_cell := _object_cells[index]
	if new_cell == old_cell:
		return
	
	if old_cell != EMPTY_CELL:
		remove(index, old_cell)
	
	add(index, new_cell)
	_object_cells[index] = new_cell

## Возвращает список индексов объектов, которые находятся в пределах заданного радиуса от точки.
## Использует пространственную сетку для быстрой отсечки заведомо далеких объектов.
##
## @param pos Позиция в мире (например, координаты пули), от которой измеряем расстояние.
## @param radius Радиус поиска в пикселях.
## @return Array Массив индексов объектов-кандидатов на коллизию.
##
## @warning Возвращает объекты из квадратной области, описывающей круг. 
## Требуется дополнительная точная проверка дистанции после вызова!
func get_objects_in_radius(pos: Vector2, radius: float) -> Array[int]:
	var result: Array = []
	var center_cell := get_cell(pos)

	# Если бы радиус пули был 150 пикселей: 150 / 100 = 1.5 → ceil(1.5) = 2.
	# Значит, нужно проверить 2 кольца клеток вокруг.
	var range_cells := ceili(radius / _cell_size)

	for x in range(-range_cells, range_cells + 1):
		for y in range(-range_cells, range_cells + 1):
			var cell := center_cell + Vector2i(x, y)
			# Мы смотрим в словарь: «А есть ли вообще кто-то в клетке (2, 2)?»
			if _grid.has(cell):
				result.append_array(_grid[cell])

	return result

# Получение объектов в конкретной ячейке
func get_objects_in_cell(cell: Vector2i) -> Array:
	if _grid.has(cell):
		return _grid[cell].duplicate()
	return []

# Полная очистка объекта (при смерти/удалении)
func remove_object(index: int) -> void:
	var old_cell := _object_cells[index]
	if old_cell != EMPTY_CELL:
		remove(index, old_cell)
	_object_cells[index] = EMPTY_CELL

func clear():
	_grid.clear()
	for i in _object_cells.size():
		_object_cells[i] = EMPTY_CELL

# --- Отладка: получение статистики ---
func get_debug_info() -> Dictionary:
	var total_objects = 0
	var max_in_cell = 0
	for key in _grid:
		var count = _grid[key].size()
		total_objects += count
		if count > max_in_cell:
			max_in_cell = count

	return {
		"active_cells": _grid.size(),
		"total_objects": total_objects,
		"max_objects_in_cell": max_in_cell,
		"_cell_size": _cell_size
	}

# --- Отладка: отрисовка сетки (вызывать из _draw в Node2D) ---
func draw_debug(canvas_item: CanvasItem, viewport_rect: Rect2, color: Color = Color(1, 1, 1, 0.1)):
	var start = viewport_rect.position
	var end = start + viewport_rect.size

	# Вертикальные линии
	for x in range(int(start.x / _cell_size), int(end.x / _cell_size) + 1):
		var pos_x = x * _cell_size
		canvas_item.draw_line(Vector2(pos_x, start.y), Vector2(pos_x, end.y), color)

	# Горизонтальные линии
	for y in range(int(start.y / _cell_size), int(end.y / _cell_size) + 1):
		var pos_y = y * _cell_size
		canvas_item.draw_line(Vector2(start.x, pos_y), Vector2(end.x, pos_y), color)
