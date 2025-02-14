@tool
extends StateAnimation

var start_pos : Vector2
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
# This additionnal callback allows you to act at the end
# of an animation

func _on_anim_finished() -> void:
	target.global_position = start_pos
	target.health_component.damage(1)
	play("RESET")
	change_state("Idle")


# This additionnal callback allows you to act at the end
# of an animation loop (after the nb of times it should play)
func _on_loop_finished() -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	if _args:
		start_pos = _args
	else:
		start_pos = Vector2.ZERO

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
