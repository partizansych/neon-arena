class_name MagicMissile extends Area2D

@export var lifetime_timer: Timer
@export var speed: float = 200.0
@export var damage: float = 1.0

var direction: Vector2 = Vector2.RIGHT

# Наносит урон сам снаряд
# Тело может обработать урон как хочет
func _on_body_enter(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_lifetime_timeout() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _ready() -> void:
	body_entered.connect(_on_body_enter)
	lifetime_timer.timeout.connect(_on_lifetime_timeout)