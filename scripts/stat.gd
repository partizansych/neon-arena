class_name Stat extends RefCounted

signal base_changed(old, new)
signal changed(old, new)

var _base_value: float
var _value: float
var _is_dirty: bool = true
var _active_mods: Array[ActiveModifier]

func _init(base_value: float, active_mods: Array[ActiveModifier] = []) -> void:
	_base_value = base_value
	_active_mods = active_mods

func _to_string() -> String:
	return "Stat: base=%s, value=%s, mods=%s" % [
		_base_value,
		_value,
		_active_mods.size()
	]

func get_base_value() -> float:
	return _base_value

func set_base_value(new: float) -> void:
	assert(new >= 0, "Аргумент new не может быть отрицательным")
	if new == _base_value: return

	_is_dirty = true
	var old = _base_value
	_base_value = new
	base_changed.emit(old, new)

func get_value() -> float:
	if not _is_dirty:
		return _value

	_is_dirty = false
	var old = _value
	var new = _calculate()
	_value = new

	changed.emit(old, new)

	return _value

func add_modifier(mod: Modifier, source: Variant = null) -> bool:
	assert(mod != null, "Аргумент mod не может быть null")
	for active in _active_mods:
		if active.mod == mod:
			return false
	_active_mods.append(ActiveModifier.new(mod, source))
	_is_dirty = true
	return true

func remove_modifier(mod: Modifier) -> bool:
	assert(mod != null, "Аргумент mod не может быть null")
	for i in range(_active_mods.size() - 1, -1, -1):
		if _active_mods[i].mod == mod:
			_active_mods.remove_at(i)
			_is_dirty = true
			return true
	return false

func remove_modifiers_from_source(source: Variant) -> int:
	assert(source != null, "Аргумент source не может быть null")
	var was_removed = 0
	for i in range(_active_mods.size() - 1, -1, -1):
		if _active_mods[i].source == source:
			_active_mods.remove_at(i)
			was_removed += 1
	if was_removed > 0:
		_is_dirty = true
	return was_removed

func _calculate() -> float:
	var total = _base_value
	var additive_multiplier = 1.0

	for active_mod in _active_mods:
		if active_mod.mod.type == Modifier.Type.FLAT:
			total += active_mod.mod.value
		else:
			additive_multiplier += active_mod.mod.value

	return total * additive_multiplier

class ActiveModifier:
	var mod: Modifier
	var source: Variant

	func _init(mod: Modifier, source: Variant = null) -> void:
		self.mod = mod
		self.source = source

enum Type {
	SPEED,
	MAX_HP,
	HP_REGEN,
	ARMOR
}
