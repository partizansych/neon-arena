class_name MagicMissileDefinition extends Weapon

# Это получается метод запуска? Или инициализирующий метод?
func activate(source: Node2D, target: Node2D, tree: SceneTree) -> void:
	var projectile: MagicMissile = scene.instantiate()
	projectile.global_position = source.global_position
	projectile.damage = damage
	projectile.speed = speed
	projectile.direction = source.global_position.direction_to(target.global_position)

	tree.current_scene.add_child(projectile)
