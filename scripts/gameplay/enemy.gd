class_name Enemy extends CharacterBody2D

@export var sprite: Sprite2D

var player_ref: Player
var speed: float = 75.0
var damage: float
var knockback: Vector2

var distance_to_player: float = INF

func setup(config: EnemyConfig) -> void:
	sprite.texture = config.texture
	damage = config.damage

func _physics_process(delta: float) -> void:
	# Дистанция
	distance_to_player = global_position.distance_to(player_ref.global_position)
	if distance_to_player > 800.0:
		queue_free()
	if distance_to_player < player_ref.nearest_enemy_distance:
		player_ref.nearest_enemy = self
	
	# Движение
	var direction := global_position.direction_to(player_ref.global_position)
	var vel := direction * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1.0)
	vel += knockback
	
	# Эффект роя
	var collision := move_and_collide(vel* delta)
	if collision:
		var collider := collision.get_collider()
		if collider is Enemy:
			collider.knockback = global_position.direction_to(collider.global_position) * 50.0

# func _ready() -> void:
	
