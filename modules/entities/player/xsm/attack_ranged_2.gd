@tool
extends StateSound

# used for calculating hook swing direction (up, down, left right)
# as well as nudge direction (360deg)
#var tether_point : Vector2

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var mouse_pos = target.get_global_mouse_position()
	var tethered_entities = get_tree().get_nodes_in_group("status_tethered")
	if tethered_entities.size() > 0:
		# There should only ever be 1 node in the status_tethered group
		var tethered_entity = tethered_entities[0]
		tethered_entity.fling(mouse_pos)
		tethered_entity.get_node("StatusHolder").remove_status("Tethered")
	
	#tether_point = target.global_position.direction_to(mouse_pos).normalized()
	#$"../../../Thread".rotation = Vector2(0, 0).angle_to_point(tether_point)
	
