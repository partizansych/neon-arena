class_name Hitbox2D extends Area2D

@export var damage: float

func _ready() -> void:
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox2D:
		area.handle_damage(damage)
