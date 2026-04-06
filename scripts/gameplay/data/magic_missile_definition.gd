class_name MagicMissileDefinition extends Weapon

# Это получается метод запуска? Или инициализирующий метод?
func activate(source: Node2D, target_pos: Vector2, tree: SceneTree) -> void:
	var projectile: MagicMissile = scene.instantiate()
	projectile.global_position = source.global_position
	projectile.damage = damage
	projectile.speed = speed
	projectile.direction = source.global_position.direction_to(target_pos)

	source.get_parent().add_child(projectile)
