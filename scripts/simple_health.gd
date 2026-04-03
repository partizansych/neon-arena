class_name SimpleHealth extends Health

var _max: float

func _init(max_value: float = 100.0) -> void:
	set_max(max_value)

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