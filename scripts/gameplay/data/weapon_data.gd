class_name WeaponData extends Resource

@export var name: String
@export var texture: Texture2D
@export var projectile_scene: PackedScene
@export var rate: float = 1.0 / 3 # N выстрелов за секунду
@export var damage: float = 1.0
@export var max_ammo: int

@export var attack_strategy: AttackStrategy

func attack(source: Node2D, target_pos: Vector2) -> void:
	attack_strategy.execute(source, target_pos, self)
