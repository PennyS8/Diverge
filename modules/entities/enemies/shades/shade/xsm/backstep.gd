@tool
extends StateAnimation

@export var nav_agent : NavigationAgent2D

## Unit: Pixels
@export var dash_distance : float

@export var dash_speed : float

var dashing
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	nav_agent.target_desired_distance = 5
	nav_agent.path_desired_distance = 10
	
	# grab player location once
	var player_position = target.follow_target.global_position
	var dash_direction = -target.global_position.direction_to(player_position).normalized()
	
	#distance in px
	var dash_force = dash_direction * dash_distance
	
	dash_force = target.to_global(dash_force)
	nav_agent.target_position = dash_force
	
	dashing = true
	play("Melee")

func _on_update(_delta: float) -> void:
	if dashing:
		if !target.follow_target:
			change_state("Roaming")
		
		if nav_agent.is_navigation_finished():
			dashing = false
		
		var current_agent_position: Vector2 = target.global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		
		target.velocity = current_agent_position.direction_to(next_path_position) * dash_speed
		target.move_and_slide()

	elif target.follow_target:
		change_state("Seeking")
	
func _on_exit(_args) -> void:
	play("RESET")

	
