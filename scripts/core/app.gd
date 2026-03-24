extends Node

@export var main_menu_scene: PackedScene
@export var game_scene: PackedScene

func _ready() -> void:
	var menu: MainMenu = get_tree().current_scene
	menu.start_requested.connect(_on_game_start_requested)

func _on_game_start_requested() -> void:
	SceneLoader.change_scene_async(game_scene.resource_path)
