#Autoload
extends Node

## Экспортируемые настройки
@export var loading_screen_scene: PackedScene
@export var use_sub_threads: bool = true

var _is_loading: bool = false
var _loading_screen: LoadingScreen = null

func change_scene_async(path: String) -> bool:
	if _is_loading:
		push_warning("SceneLoader: Already loading a scene. Request ignored.")
		return false
	
	_is_loading = true
	await _show_loading_screen()

	var error: Error = ResourceLoader.load_threaded_request(path, "", use_sub_threads)
	if error != OK:
		push_error("SceneLoader: Failed to start threaded load: %s" % error_string(error))
		_reset()
		return false

	var progress: Array[float] = [0.0]
	while _is_loading:
		var status := ResourceLoader.load_threaded_get_status(path, progress)
		match status:
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("SceneLoader: Invalid resource: %s" % path)
				await _reset()
			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("SceneLoader: Failed: %s" % path)
				await _reset()
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame
			ResourceLoader.THREAD_LOAD_LOADED:
				var resource := ResourceLoader.load_threaded_get(path)
				get_tree().change_scene_to_packed(resource)
				await _reset()
				return true
	return false

func _reset() -> void:
	_is_loading = false
	if _loading_screen != null:
		await _hide_loading_screen()

func _show_loading_screen() -> void:
	_loading_screen = loading_screen_scene.instantiate()
	add_child(_loading_screen)
	await _loading_screen.fade_in()

func _hide_loading_screen() -> void:
	await _loading_screen.fade_out()
	_loading_screen.queue_free()
	_loading_screen = null
