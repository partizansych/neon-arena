class_name HazardZone extends Area2D

@export var damage: float

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
	elif area.owner.has_method("take_damage"):
		area.owner.take_damage(damage)
