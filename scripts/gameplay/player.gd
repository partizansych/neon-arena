class_name Player extends CharacterBody2D


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = 300.0 #get_stat_value(Stat.Type.SPEED)
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed

	move_and_slide()