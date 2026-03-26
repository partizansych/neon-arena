class_name LoadingScreen extends CanvasLayer

@export var animation_player: AnimationPlayer

func fade_in() -> void:
	animation_player.play("transition")
	await animation_player.animation_finished

func fade_out() -> void:
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()