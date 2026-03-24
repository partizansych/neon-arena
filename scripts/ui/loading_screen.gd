class_name LoadingScreen extends CanvasLayer

signal fade_in_finished()
signal fade_out_finished()

@export var animation_player: AnimationPlayer
@export var progress_bar: ProgressBar
@export var status_label: Label
@export var scene_name_label: Label

func fade_in() -> void:
	animation_player.play("transition")
	await animation_player.animation_finished
	fade_in_finished.emit()

func fade_out() -> void:
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	fade_out_finished.emit()
	queue_free()

func _ready() -> void:
	fade_in()
