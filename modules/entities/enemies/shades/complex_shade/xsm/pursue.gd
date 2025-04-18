@tool
extends State

@export var chase_speed := 60.0

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

var target_angle

@export var strafe_factor := 0.25
# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	if !_args:
		return
		
	target.movement_speed = chase_speed
	
	target.ai_steering.apply_seek(_args)
	target.ai_steering.apply_strafe(_args, strafe_factor)

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
