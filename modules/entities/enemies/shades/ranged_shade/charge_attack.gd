@tool
extends StateAnimation

# This additionnal callback allows you to act at the end
# of an animation

# TODO: when we have an 'attack charge' animation, move the code from
# timer timeout to here instead.
func _on_anim_finished() -> void:
	pass

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	change_state("Attack", target.follow_target.global_position - Vector2(0, 8))
