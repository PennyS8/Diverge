@tool
extends State


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	# Needs to be cleared at the start to reset data from last frame
	target.ai_steering.clear()
	
	#var tween = target.create_tween().set_parallel(true)
	#var end_position = target.global_position + Vector2(randi_range(-24, 24), randi_range(24, 32))
	#tween.tween_property(target, "global_position", end_position, 2.0)
	#
	#if LevelManager.player.in_cutscene:
		#tween.chain().tween_callback(LevelManager.player.exit_cutscene)
		
	#tween.chain().tween_callback(target.queue_free)
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
