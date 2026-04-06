class_name PlayerStateReader
#TODO: PlayerStateWriter

var _player: Player

func _init(player: Player) -> void:
	_player = player

func get_pos() -> Vector2:
	return _player.global_position
