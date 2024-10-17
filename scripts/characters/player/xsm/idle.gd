@tool
extends StateSound

func _on_enter(_args):
	change_state("CanAttack")
	
# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if target.dir != Vector2.ZERO:
		change_state("Walk")
		
