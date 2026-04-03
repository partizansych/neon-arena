class_name MultiMeshManager extends MultiMeshInstance2D

func appear(index: int, pos: Vector2) -> void:
	var new_transform := Transform2D(0, pos)
	multimesh.set_instance_transform_2d(index, new_transform)

func camouflage(index: int) -> void:
	var hide_transform := Transform2D(0, Vector2(-99999, -99999))
	multimesh.set_instance_transform_2d(index, hide_transform)