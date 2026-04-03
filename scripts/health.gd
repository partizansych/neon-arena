@icon("res://editor/heart.svg")
@abstract
class_name Health extends Node

signal current_changed(old: float, new: float)
signal max_changed(old: float, new: float)
signal died()

var _current: float

@abstract
func get_max() -> float

@abstract
func set_max(new_value: float) -> void

func get_current() -> float:
	return _current

## Позволяет задать выше max
func set_current(new_value: float) -> void:
	if new_value < 0.0:
		push_error("Health: аргумент не должен быть отрицательным: %d" % new_value)
		return
	
	if new_value == _current:
		return

	var old_value := _current
	_current = new_value
	current_changed.emit(old_value, new_value)

	if _current == 0.0:
		die()

## Более безопасная версия (в игре стоит использовать этот метод, вместо set_current)
func reduce(amount: float) -> void:
	if amount <= 0.0:
		push_error("Health: аргумент должен быть положительным: %d" % amount)
		return
	
	if _current == 0.0:
		return

	var old_value := _current
	var new_value := clampf(_current - amount, 0.0, get_max())
	_current = new_value
	current_changed.emit(old_value, new_value)

	if _current == 0.0:
		die()

func restore(amount: float) -> void:
	if amount <= 0.0:
		push_error("Health: аргумент должен быть положительным: %d" % amount)
		return
	
	var max_value := get_max()
	if _current == max_value:
		return

	var old_value := _current
	var new_value := clampf(_current + amount, 0.0, max_value)
	_current = new_value
	current_changed.emit(old_value, new_value)

func die() -> void:
	died.emit()