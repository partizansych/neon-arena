class_name HealthPopup extends Node2D

@export var health_comp: HealthComponent
@export var damage_popup_scene: PackedScene

func _on_health_changed(old: float, new: float) -> void:
	var popup: DamagePopup = damage_popup_scene.instantiate()
	popup.global_position = global_position
	get_tree().current_scene.add_child(popup)
	popup.bind_damage(str(new - old))

func _ready() -> void:
	health_comp.changed.connect(_on_health_changed)