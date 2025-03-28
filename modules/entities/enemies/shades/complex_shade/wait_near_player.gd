@tool
extends State

@export var desired_distance : int
@export var state_speed : float
@onready var nav_agent = %NavAgent
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	target.movement_speed = state_speed


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args):
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	var enemy_position : Vector2 = target.global_position
	var player_position : Vector2 = target.follow_object.global_position
	var player_distance : float = player_position.distance_to(enemy_position)
	if player_distance < desired_distance:
		# desired location is straight backward +- 20degrees
		var desired_location = player_position.direction_to(enemy_position).normalized()
		desired_location = desired_location * (desired_distance-player_distance)
		target.set_movement_goal(target.to_local(desired_location))

	else:
		# desired location a point on circle of radius=desired_distance from player
		pass
	

	# if we've reached our desired point
	if nav_agent.is_navigation_finished():
		# chase checks if we can engage; if not, it transitions back to this state
		change_state("Chase")


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
