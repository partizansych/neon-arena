class_name Enemy extends CharacterBody2D

@export var sprite: Sprite2D

var player_ref: Node2D
var speed: float = 75.0
var damage: float
var knockback: Vector2

func setup(config: EnemyConfig) -> void:
	sprite.texture = config.texture
	damage = config.damage

func _physics_process(delta: float) -> void:
	var distance: float = global_position.distance_to(player_ref.global_position)
	if distance > 800.0:
		queue_free()
	
	var direction := global_position.direction_to(player_ref.global_position)
	var vel := direction * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1.0)
	vel += knockback
	
	var collision := move_and_collide(vel* delta)
	if collision:
		var collider := collision.get_collider()
		if collider is Enemy:
			collider.knockback = global_position.direction_to(collider.global_position) * 50.0

# func _ready() -> void:
	
