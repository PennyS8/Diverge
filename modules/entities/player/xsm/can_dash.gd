@tool
extends State


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

func _on_enter(_args):
	target.unhandled_input_received.connect(state_unhandled_input)

func _on_update(_delta):
	pass

func state_unhandled_input(event):
	if Input.is_action_just_pressed("dash"):
		change_state("Recall")
		change_state("Dash")
		change_state("NoAttack")
		
func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
