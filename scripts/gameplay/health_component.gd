class_name HealthComponent extends Node

signal changed(old: float, new: float)
signal died()

@export var max_health: float = 100.0
@export var is_invulnerable: bool = false

var current_health: float:
	set(value):
		value = clampf(value, 0.0, max_health)
		if value == current_health:return
		if value == 0.0:
			die()
		var old: float = current_health
		current_health = value
		changed.emit(old, current_health)

func die() -> void:
	died.emit()

func _ready() -> void:
	current_health = max_health