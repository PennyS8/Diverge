@tool
extends State

func _on_enter(_args) -> void:
	target.unhandled_input_received.connect(state_unhandled_input)

	
func state_unhandled_input(event : InputEvent):
	if is_active("MovementDisabled"):
		return
		
	var num_tethered_nodes = get_tree().get_node_count_in_group("status_tethered")
	
	if Input.is_action_just_pressed("attack_melee"):
		change_state("AttackMelee")
	elif Input.is_action_just_pressed("lasso"):
		# Prevents the player from lassoing before recalling the yarn
		if num_tethered_nodes < 1:
			change_state("Lasso")
		elif num_tethered_nodes == 2:
			# Find the targeted tethered node (not the player)
			var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
			var tethered_node = tethered_nodes[0]
			if tethered_node.is_in_group("player"):
				tethered_node = tethered_nodes[1]
			tethered_node.fling()
	elif Input.is_action_just_pressed("throw"):
		if num_tethered_nodes == 2:
			change_state("Throw")
# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass
	
func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
