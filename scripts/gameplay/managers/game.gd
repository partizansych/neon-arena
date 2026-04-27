class_name Game extends Node

signal exit_to_menu_requested()
signal exit_app_requested()

@export var player: Player
@export var enemy_spawner: EnemySpawner
@export_group("UI")
@export var canvas: CanvasLayer
@export var pause_menu_scene: PackedScene

var _pause_menu: PauseMenu

func _exit_tree() -> void:
	# При переключении сцен может остаться пауза,
	# поэтому гарантировано сбрасываем состояние при смене
	get_tree().paused = false

func _ready() -> void:
	enemy_spawner.bind_player(player)
	enemy_spawner.bind_enemies_parent(%Pausable)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause() -> void:
	var tree := get_tree()
	if tree.paused:
		return
	tree.paused = true
	_show_pause_menu()

func resume() -> void:
	var tree := get_tree()
	if not tree.paused:
		return
	tree.paused = false
	_hide_pause_menu()

func _show_pause_menu() -> void:
	_pause_menu = pause_menu_scene.instantiate()
	canvas.add_child(_pause_menu)
	# Просто пересылаем сигнал без логики? Зачем тогда Game?
	# _pause_menu.exit_to_menu_requested.connect(exit_to_menu_requested.emit)
	_pause_menu.exit_to_menu_requested.connect(_on_pause_menu_exit)
	_pause_menu.resume_requested.connect(resume)

func _hide_pause_menu() -> void:
	_pause_menu.queue_free()
	_pause_menu = null

func _on_pause_menu_exit() -> void:
	# 1. Сначала делаем важные дела на уровне игры
	# save_progress()
	# stop_music()
	# cleanup_enemies()

	# 2. Потом сообщаем выше, что готовы закрыть сцену
	exit_to_menu_requested.emit()
