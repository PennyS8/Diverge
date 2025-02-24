@tool
extends StateAnimation

@export var nav_agent : NavigationAgent2D

## Unit: Pixels
@export var dash_distance : float

## Unit: seconds
@export var dash_time : float
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	# grab player location once
	var player_position = target.follow_target.global_position
	var dash_direction = target.global_position.direction_to(player_position).normalized()
	
	#distance in px
	var dash_force = dash_direction * dash_distance
	
	dash_force = target.to_global(dash_force)
	var tween = target.create_tween()
	tween.tween_property(target, "global_position", dash_force, dash_time)
	
	play("Melee")

func _on_update(_delta: float) -> void:
	nav_agent.target_position = target.follow_target.global_position
	
	
