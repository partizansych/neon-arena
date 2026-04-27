class_name Hurtbox2D extends Area2D

signal damaged(amount: float)

func _ready() -> void:
	monitorable = true
	monitoring = false

func handle_damage(damage: float) -> void:
	damaged.emit(damage)
