@tool
extends State


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
func _on_update(_delta):
	if Input.is_action_just_pressed("dash"):
		change_state("Dash")
		change_state("DashTimer")
		change_state("NoAttack")
