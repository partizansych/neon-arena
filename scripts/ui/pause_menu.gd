class_name PauseMenu extends Control

signal resume_requested()
signal open_settings_requested()
signal exit_to_menu_requested()
signal exit_app_requested()

func _ready() -> void:
	%ResumeButton.pressed.connect(_on_resume_button_pressed)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_resume_button_pressed() -> void:
	resume_requested.emit()

func _on_settings_button_pressed() -> void:
	pass

func _on_exit_button_pressed() -> void:
	exit_to_menu_requested.emit()
