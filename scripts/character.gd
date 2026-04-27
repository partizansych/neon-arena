@abstract
class_name Character extends CharacterBody2D
## Общий класс для игрока и врагов

signal took_damage(amount: float)

@export_group("Компоненты")
@export var health: Health
@export var iframe: IFrame

var stats: Dictionary[Enum.Stat, Stat]

func _ready() -> void:
	health.current_changed.connect(_on_health_changed)
	
	for type in Enum.Stat.values():
		if not stats.has(type):
			stats[type] = Stat.new(0.0)

func take_damage(amount: float):
	if not iframe.is_running():
		health.reduce(amount)
		iframe.start()

func take_heal(amount: float):
	health.restore(amount)

func _on_health_changed(old: float, new: float) -> void:
	if old > new:
		took_damage.emit(old - new)
