@tool
extends StateAnimation

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the end
# of an animation

# NATE: TODO: when we have an 'attack charge' animation, move the code from
# timer timeout to here instead.
func _on_anim_finished() -> void:
	pass

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	pass
	#target.modulate = Color.REBECCA_PURPLE

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	change_state("Attack", target.follow_target.global_position - Vector2(0, 8))


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
