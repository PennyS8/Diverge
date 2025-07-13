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

func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
