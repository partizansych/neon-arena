class_name Player extends CharacterBody2D

@export var health: Health
@export var hurtbox: Area2D
@export var iframe_timer: Timer

@export_group("Оружие")
@export var weapon_cooldown_timer: Timer
@export var weapon: Weapon

var in_iframe: bool
var nearest_enemy
var nearest_enemy_distance: float = INF

func _ready() -> void:
	hurtbox.body_entered.connect(_on_body_entered)
	weapon_cooldown_timer.timeout.connect(_on_weapon_timer_ended)
	iframe_timer.timeout.connect(_on_iframe_timer_ended)

func _physics_process(delta: float) -> void:
	# Ближайший враг
	if nearest_enemy:
		nearest_enemy_distance = nearest_enemy.distance_to_player
	else:
		nearest_enemy_distance = INF

	# Движение
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = 300.0 #get_stat_value(Stat.Type.SPEED)
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed

	move_and_slide()

#region Здоровье
func damage(amount: float) -> void:
	if in_iframe:
		return
	health.reduce(amount)
	_start_iframe()

func heal(amount: float) -> void:
	health.restore(amount)
#endregion

#region IFrame
func _on_iframe_timer_ended() -> void:
	in_iframe = false

func _start_iframe() -> void:
	in_iframe = true
	iframe_timer.start()
#endregion

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		damage(body.damage)

func _on_weapon_timer_ended() -> void:
	if nearest_enemy:
		weapon.activate(self, nearest_enemy, get_tree())
