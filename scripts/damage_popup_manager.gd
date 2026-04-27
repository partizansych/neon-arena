extends Node2D

@export var popup_scene: PackedScene

func _ready() -> void:
	var nodes := get_tree().get_nodes_in_group("characters")
	for node in nodes:
		connect_to_node(node)

	get_tree().node_added.connect(on_node_added)

func _exit_tree() -> void:
	get_tree().node_added.disconnect(on_node_added)

func connect_to_node(node: Node2D) -> void:
	if node.has_signal("took_damage"):
		node.took_damage.connect(on_damage_received.bind(node))

func on_node_added(node: Node) -> void:
	if node.is_in_group("characters"):
		connect_to_node(node)

func on_damage_received(amount: float, node: Node2D) -> void:
	var popup: DamagePopup = popup_scene.instantiate()
	popup.bind_damage(str(amount))
	popup.global_position = node.global_position
	add_child(popup)
