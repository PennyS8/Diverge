@tool
extends StateSound


# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	for entity in get_tree().get_nodes_in_group("status_tethered"):
		entity.remove_tethered_status()
		var yarn = entity.get_node_or_null("YarnController")
		if yarn:
			yarn.queue_free()
