extends StateSound

func _on_enter(_args) -> void:
	var selected_node = get_tree().get_first_node_in_group("selected")
	
	# Check for valid selected node in range to collide with node being thrown
	if selected_node:
		# Check for invalid selected nodes
		var dist = %yarn.tethered_body.global_position.distance_to(selected_node.global_position)
		if (
			selected_node.is_in_group("lever") or
			%yarn.tethered_body.is_in_group("lever") or
			dist > target.yarn_length
		):
			selected_node.deselect()
			selected_node = null
		
		# Pull the tethered_body and the selected_node toward eachother, if able
		else:
			selected_node.add_tethered_status()
			target.remove_tethered_status()
			target.get_node_or_null("YarnController").queue_free()
			
			selected_node.deselect()
			
			selected_node.pull()
			%yarn.tethered_body.pull()
			
			selected_node.remove_tethered_status()
			%yarn.tethered_body.remove_tethered_status()
