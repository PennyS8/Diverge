@tool
extends StateSound

var idle_dir : Vector2

func _on_enter(_args):
	if !target.in_cutscene:
		change_state("CanAttack")
	
	var no_hook = ""
	if target.hook_locked:
		no_hook = "no_spear/"
	
	if(_args):
		target.idle_dir = _args
		
	match target.idle_dir:
		Vector2.UP:
			play_blend(no_hook + "idle_up", 0.0)
		Vector2.RIGHT:
			play_blend(no_hook + "idle_right", 0.0)
		Vector2.LEFT:
			play_blend(no_hook + "idle_left", 0.0)
		Vector2.DOWN:
			play_blend(no_hook + "idle_down", 0.0)


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if target.dir != Vector2.ZERO:
		change_state("Walk")
	
	var no_hook = ""
	if target.hook_locked:
		no_hook = "no_spear/"
		
	match target.idle_dir:
		Vector2.UP:
			play(no_hook + "idle_up")
		Vector2.RIGHT:
			play(no_hook + "idle_right")
		Vector2.LEFT:
			play(no_hook + "idle_left")
		Vector2.DOWN:
			play(no_hook + "idle_down")
	
