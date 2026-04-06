class_name Player extends CharacterBody2D

@export var _damage_popup_scene: PackedScene

@export var _health: Health
@export var _iframe: IFrame

@export_group("Оружие")
@export var weapon: Weapon

func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	look_at(mouse_pos)

	if Input.is_action_just_pressed("attack"):
		weapon.activate(self, mouse_pos, get_tree())

func _physics_process(delta: float) -> void:
	# Движение
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = 300.0 #get_stat_value(Stat.Type.SPEED)
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed

	move_and_slide()

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
