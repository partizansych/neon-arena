class_name Weapon extends Resource

@export var name: String
@export var texture: Texture2D
@export var damage: float
@export var cooldown: float
@export var speed: float
@export var scene: PackedScene

func activate(source: Node2D, target: Node2D, tree: SceneTree) -> void:
	pass