@tool
extends StateAnimation

## THIS STATE EXITS BASED ON THE CONDITIONS OF THE TIMER ATTACHED TO IT.
## WE POSSIBLY WANT TO PASS THIS IN AS A PARAMETER OR SOMETHING. THE TIMER IS FOR DEBUG.
## I LOVE YOU.

# This additionnal callback allows you to act at the end
# of an animation
func _on_anim_finished():
	change_state("Melee")


# This additionnal callback allows you to act at the end
# of an animation loop (after the nb of times it should play)
func _on_loop_finished():
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	pass


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args):
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	pass


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta):
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args):
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args):
	pass


# when StateAutomaticTimer timeout()
func _state_timeout():
	pass


# Called when any other Timer times out
func _on_timeout(_name):
	pass
