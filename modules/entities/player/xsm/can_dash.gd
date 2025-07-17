@tool
extends State


func _on_enter(_args):
	target.unhandled_input_received.connect(state_unhandled_input)

func state_unhandled_input(_event):
	if Input.is_action_just_pressed("dash"):
		change_state("Dash")
		change_state("NoAttack")
		
func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
