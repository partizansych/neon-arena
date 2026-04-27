class_name WeaponController extends Node2D

@export var heavy_reload_timer: Timer
@export var primary_reload_timer: Timer
@export var heavy_weapon_data: WeaponData
@export var primary_weapon_data: WeaponData

var heavy_weapon: ActiveWeapon
var primary_weapon: ActiveWeapon
var current_weapon: ActiveWeapon 
var is_shooting: bool
var is_reloading: bool

#func set_heavy(data: WeaponData) -> void:
	#var old := heavy_weapon
	#heavy_weapon = ActiveWeapon.new(data)
	#if current_weapon == old:
		#current_weapon

func set_primary(data: WeaponData) -> void:
	primary_weapon = ActiveWeapon.new(data)

func switch_to_heavy() -> void:
	if heavy_weapon:
		current_weapon = heavy_weapon

func switch_to_primary() -> void:
	if primary_weapon:
		current_weapon = primary_weapon

func do_shot() -> void:
	if not current_weapon.can_do_shot(): return
	current_weapon.do_shot()
	# spawn_bullet()

func reload() -> void:
	if current_weapon.can_reload():
		current_weapon.reload()

func start_shoot() -> void:
	is_shooting = true

func stop_shoot() -> void:
	is_shooting = false

func _ready() -> void:
	pass
	#heavy_weapon = ActiveWeapon.new(heavy_weapon_data)
	#primary_weapon = ActiveWeapon.new(primary_weapon_data)
	#current_weapon = primary_weapon

func _process(delta: float) -> void:
	if heavy_weapon: heavy_weapon.wait(delta)
	if primary_weapon: primary_weapon.wait(delta)
	if is_shooting: do_shot()

class ActiveWeapon:
	var data: WeaponData
	var time_since_shot: float
	var ammo: int

	func _init(data: WeaponData) -> void:
		self.data = data
		time_since_shot = data.rate

	func wait(time: float) -> void:
		time_since_shot += time

	func can_do_shot() -> bool:
		return time_since_shot >= data.rate and ammo > 0

	func do_shot() -> void:
		time_since_shot = 0.0
		ammo -= 1

	func can_reload() -> bool:
		return ammo < data.max_ammo

	func reload() -> void:
		ammo = data.max_ammo
