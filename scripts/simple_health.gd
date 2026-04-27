@icon("res://editor/heart.svg")
class_name SimpleHealth extends Health

@export var _max: float = 100.0

func get_max() -> float:
	return _max

func set_max(new_value: float) -> void:
	if new_value < 0.0:
		push_error("SimpleHealth: аргумент не должен быть отрицательным: %d" % new_value)
		return
	
	if new_value == _max:
		return
	
	var old_value := _max
	_max = new_value
	max_changed.emit(old_value, new_value)

	if _max == 0.0:
		die()
