@tool
extends StateSound

var idle_dir : Vector2

func _on_enter(_args):
	if !target.in_cutscene:
		change_state("CanAttack")
	
	if(_args):
		idle_dir = _args
	else:
		idle_dir = Vector2.DOWN
	
	match idle_dir:
		Vector2.UP:
			play_blend("idle_up", 0.0)
		Vector2.RIGHT:
			play_blend("idle_right", 0.0)
		Vector2.LEFT:
			play_blend("idle_left", 0.0)
		Vector2.DOWN:
			play_blend("idle_down", 0.0)


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if target.dir != Vector2.ZERO:
		change_state("Walk")
	
	match idle_dir:
		Vector2.UP:
			play("idle_up")
		Vector2.RIGHT:
			play("idle_right")
		Vector2.LEFT:
			play("idle_left")
		Vector2.DOWN:
			play("idle_down")
	
