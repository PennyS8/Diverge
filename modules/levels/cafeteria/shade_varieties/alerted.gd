@tool
extends StateAnimation

func _before_exit(_args) -> void:
	target.follow_target = get_tree().get_first_node_in_group("player")
