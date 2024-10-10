@tool
extends StateRand


# FUNCTIONS TO INHERIT #

# COMMENTED: DEFAULT ANIMATION IS SET IN THE INSPECTOR in Idle State
# func _on_enter(_args):
# 	play("Idle")


func _on_update(_delta):
	if Input.is_action_just_pressed("ui_down"):
		var _s = change_state("Crouch")	


func _after_update(_delta):
	if target.dir == 0:
		target.velocity.x = 0
