@tool
extends State

# Moves into the "CanDash" state that is listen in the "Next State" property
func _on_enter(_args):
	change_to_next()
