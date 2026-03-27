class_name HealthBar extends ProgressBar

@export var health_comp: HealthComponent

func _on_health_changed(old: float, new: float) -> void:
	value = new

func _ready() -> void:
	min_value = 0.0
	max_value = health_comp.max_health
	health_comp.changed.connect(_on_health_changed)