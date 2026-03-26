class_name Enemy extends CharacterBody2D

@export var player_ref: Node2D
var speed: float = 75.0

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player_ref.global_position)
	move_and_collide(direction * speed * delta)