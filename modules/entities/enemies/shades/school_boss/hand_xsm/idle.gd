@tool
extends StateSound

const ATTACK_RANGE = 48.0

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	target.follow_object = get_tree().get_first_node_in_group("player")

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if target.follow_object == null:
		target.follow_object = get_tree().get_first_node_in_group("player")
	else:
		var target_position = target.follow_object.global_position
		var displacement = target_position - target.global_position
		
		var distance = displacement.length()
		var target_angle = displacement.angle()
		
		if distance <= ATTACK_RANGE:
			change_state("ChargeSlam")

# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass

# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass

# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
