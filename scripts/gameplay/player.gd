class_name Player extends CharacterBody2D

@export var health_comp: HealthComponent
@export var iframe_timer: Timer
@export_group("Оружие")
@export var weapon_cooldown_timer: Timer
@export var weapon: Weapon

var in_iframe: bool
var nearest_enemy
var nearest_enemy_distance: float = INF

# func damage(amount: float) -> void:

func take_damage(damage: float) -> void:
	if in_iframe:
		return
	health_comp.current_health -= damage

	in_iframe = true
	iframe_timer.start()
	#TODO: Начать мигание

func _on_iframe_timer_ended() -> void:
	in_iframe = false
	#TODO: Закончить мигание

func _on_weapon_timer_ended() -> void:
	if nearest_enemy:
		weapon.activate(self, nearest_enemy, get_tree())

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

func _ready() -> void:
	iframe_timer.timeout.connect(_on_iframe_timer_ended)
	weapon_cooldown_timer.timeout.connect(_on_weapon_timer_ended)
