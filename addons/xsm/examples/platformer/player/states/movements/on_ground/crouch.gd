@tool
extends StateAnimation


# FUNCTIONS TO INHERIT #

# COMMENTED: DEFAULT ANIMATION IS SET IN THE INSPECTOR in Crouch State
# func _on_enter(_args):
# 	play("Crouch")


func _on_update(_delta):
	if Input.is_action_just_released("crouch"):
		var _s = change_state("Idle")
