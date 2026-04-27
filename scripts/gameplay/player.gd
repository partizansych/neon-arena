class_name Player extends Character

func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	look_at(mouse_pos)

	if Input.is_action_just_pressed("attack"):
		pass
		#weapon_controller.shot(global_transform.x)

func _physics_process(delta: float) -> void:
	# Движение
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = 300.0 #get_stat_value(Stat.Type.SPEED)
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed

	move_and_slide()
