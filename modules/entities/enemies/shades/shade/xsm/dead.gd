@tool
extends StateAnimation

func _after_enter(_args) -> void:
	target.get_node("ShadeFSM").disabled = true
