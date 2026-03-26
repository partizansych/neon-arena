extends Node

@export_file var main_menu_path: String
@export_file var game_path: String

func _setup_scene_signals(scene: Node) -> void:
	if scene is MainMenu:
		scene.start_requested.connect(_change_to_game)
	elif scene is Game:
		scene.exit_to_menu_requested.connect(_change_to_menu)

func _change_to_menu() -> void:
	if await SceneLoader.change_scene_async(main_menu_path):
		_setup_scene_signals(get_tree().current_scene)
		
func _change_to_game() -> void:
	if await SceneLoader.change_scene_async(game_path):
		_setup_scene_signals(get_tree().current_scene)

func _ready() -> void:
	_setup_scene_signals(get_tree().current_scene)
