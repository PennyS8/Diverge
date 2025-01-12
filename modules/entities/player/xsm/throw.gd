@tool
extends StateSound


# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var num_tethered_entities = $"/root/StatusEffectsManager".num_tethered_entities()
	var tethered_entities = get_tree().get_nodes_in_group("status_tethered")
	if num_tethered_entities == 1:
		var tethered_entity = tethered_entities[0]
		if tethered_entity.name == "Player":
			tethered_entity = tethered_entities[1]
		tethered_entity.get_node("StatusHolder").fling_tethered_entity(mouse_pos)
	
	change_state("Idle")

func _on_exit(_args) -> void:
	change_state("CanAttack")
