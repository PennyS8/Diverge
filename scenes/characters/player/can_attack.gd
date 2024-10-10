@tool
extends State


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		change_state("Attack")
		change_state("DashTimer")
