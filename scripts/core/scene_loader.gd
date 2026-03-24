#Autoload
extends Node

## Экспортируемые настройки
@export var loading_screen_scene: PackedScene
@export var use_sub_threads: bool = true

## Внутреннее состояние
var _current_load_path: String = ""
var _loading_screen: LoadingScreen = null
var _is_loading: bool = false

func change_scene_async(path: String) -> void:
	if _is_loading:
		push_warning("SceneLoader: Already loading a scene. Request ignored.")
		return

	_current_load_path = path
	_is_loading = true
	await _show_loading_screen()

	var err := ResourceLoader.load_threaded_request(path, "", use_sub_threads)
	if err != OK:
		_hide_loading_screen()
		_reset_state()
		push_error("SceneLoader: Failed to start threaded load: %s" % error_string(err))
		return
	set_process(true)

## Внутренние методы
func _show_loading_screen() -> void:
	_loading_screen = loading_screen_scene.instantiate()
	add_child(_loading_screen)
	await _loading_screen.fade_in_finished

func _hide_loading_screen() -> void:
	await _loading_screen.fade_out()
	_loading_screen.queue_free()
	_loading_screen = null

func _reset_state() -> void:
	_is_loading = false
	_current_load_path = ""
	set_process(false)

func _ready():
	_reset_state()

func _process(_delta: float) -> void:
	var progress: Array
	var status := ResourceLoader.load_threaded_get_status(_current_load_path, progress)
	print("s")

	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			var resource := ResourceLoader.load_threaded_get(_current_load_path)
			get_tree().change_scene_to_packed(resource)
			_reset_state()
			_hide_loading_screen()
