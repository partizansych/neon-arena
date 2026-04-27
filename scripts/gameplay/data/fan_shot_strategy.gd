class_name FanShotStrategy extends AttackStrategy

@export var projectile_scene: PackedScene
@export var count: int = 3
@export_range(1.0, 360.0, 1.0) var spread_degrees: float = 30.0

func execute(source: Node2D, target_pos: Vector2, data: WeaponData) -> void:
	var base_dir := (target_pos - source.global_position).normalized()
	var start_angle := -deg_to_rad(spread_degrees) / 2.0
	var step_angle := deg_to_rad(spread_degrees) / (count - 1) if count > 1 else 0.0

	for i in range(count):
		var angle := start_angle + (step_angle * i)
		var dir := base_dir.rotated(angle)
		
		var projectile := projectile_scene.instantiate()
		source.get_tree().root.add_child(projectile)
		projectile.global_position = source.global_position
		projectile.rotation = dir.angle()
		
		if projectile.has_method("setup"):
			projectile.setup(data.damage)
			
		if projectile.has_method("launch"):
			projectile.launch(dir)
