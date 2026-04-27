class_name Enemy extends Character

@export var speed: float = 75.0

var _target: Node2D

func setup(data: EnemyData) -> void:
	speed = data.speed
	$Hitbox2D.damage = data.damage
	if data.material != null:
		global_scale *= 1.5

func set_target(target: Node2D) -> void:
	_target = target

func _process(delta: float) -> void:
	if _target:
		look_at(_target.global_position)

func _physics_process(delta: float) -> void:
	if _target == null: return
	var dir_to_player := global_position.direction_to(_target.global_position)
	move_and_collide(dir_to_player * speed * delta)
