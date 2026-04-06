class_name Enemy extends CharacterBody2D

@export var _damage_popup_scene: PackedScene

@export var _health: Health
@export var _iframe: IFrame

@export var speed: float = 75.0
@export var damage: float = 2.0

var player: PlayerStateReader

func _process(delta: float) -> void:
	look_at(player.get_pos())

func _physics_process(delta: float) -> void:
	var dir_to_player := global_position.direction_to(player.get_pos())
	
	move_and_collide(dir_to_player * speed * delta)

func take_damage(amount: float) -> void:
	if not _iframe.is_running():
		_spawn_damage_popup(amount)
		_health.reduce(amount)
		_iframe.start()

func take_heal(amount: float) -> void:
	_health.restore(amount)

func _spawn_damage_popup(damage: float) -> void:
	var popup: DamagePopup = _damage_popup_scene.instantiate()
	popup.bind_damage(str(damage))
	popup.global_position = global_position
	get_parent().add_child(popup)
