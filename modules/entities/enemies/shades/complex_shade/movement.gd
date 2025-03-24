@tool
extends State

@export var nav_agent : NavigationAgent2D
@export var soft_collision : Area2D


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

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
	## NATE: This is in after_update because we wait for any changes to 
	## the end position we make in child states before moving that way
	
	var current_agent_position: Vector2 = target.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	target.velocity = current_agent_position.direction_to(next_path_position) * target.movement_speed
	
	if soft_collision.is_colliding():
		target.velocity += soft_collision.get_push_vector() * _delta * 600
	
	target.move_and_slide()


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
