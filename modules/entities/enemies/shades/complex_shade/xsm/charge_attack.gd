@tool
extends StateAnimation


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

## The amount of time before we transition to the actual attack
@export var charge_time : float
var remaining_time : float

# This additionnal callback allows you to act at the end
# of an animation
func _on_anim_finished() -> void:
	pass


# This additionnal callback allows you to act at the end
# of an animation loop (after the nb of times it should play)
func _on_loop_finished() -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	remaining_time = charge_time
	pick_charge_anim()

func pick_charge_anim():
	var my_position = target.global_position
	var attack_position = target.follow_object.global_position
	
	var attack_direction = my_position.direction_to(attack_position).normalized()
	var xdir = attack_direction.snapped(Vector2.ONE).x
	var ydir = attack_direction.snapped(Vector2.ONE).y
	
	match [xdir, ydir]:
		[1.0, _]:
			play_blend("charge_right", 0.0)
		[-1.0, _]:
			play_blend("charge_left", 0.0)
		[0.0, 1.0]:
			play_blend("charge_down", 0.0)
		[0.0, -1.0]:
			play_blend("charge_up", 0.0)
		[_, _]:
			play_blend("charge_down", 0.0)
# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if remaining_time <= 0:
		change_state("Attack")
	
	#easiest way to do a timer. just subtract time since last frame
	remaining_time = remaining_time - _delta


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
