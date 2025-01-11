@tool
extends StateSound


# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var tethered_entities = get_tree().get_nodes_in_group("status_tethered")
	if tethered_entities.size() == 1:
		var tethered_entity = tethered_entities[0]
		tethered_entity.fling(mouse_pos)
	
	change_state("Idle")

func _on_exit(_args) -> void:
	change_state("CanAttack")
