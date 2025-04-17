@tool
extends StateAnimation


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	pass

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	target.velocity = target.knockback
	target.move_and_slide()
	
	if target.crowd_control == true:
		# No knockback if the enemy is trapped
		target.knockback = lerp(Vector2.ZERO, Vector2.ZERO, 0.0)
	else:
		target.knockback = lerp(target.knockback, Vector2.ZERO, _delta*10)


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	var hurtbox = target.hurtbox
	hurtbox.set_collision_mask_value(13, false)
	hurtbox.set_collision_mask_value(3, true)


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	EnemyManager.mark_for_disengage(target)


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
