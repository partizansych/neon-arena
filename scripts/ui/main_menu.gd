class_name MainMenu extends Control

signal game_started()
signal app_exited()

@export var _start_game_button: Button
@export var _open_settings_button: Button
@export var _exit_button: Button

func _ready() -> void:
	_start_game_button.pressed.connect(_on_start_game_button_pressed)
	_exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_game_button_pressed() -> void:
	game_started.emit()

func _on_exit_button_pressed() -> void:
	app_exited.emit()
