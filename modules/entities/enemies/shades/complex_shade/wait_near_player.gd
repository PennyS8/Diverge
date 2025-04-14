@tool
extends State

@export var desired_distance : float
@export var personal_bubble_radius : float
@export var state_speed : float
@onready var nav_agent = %NavAgent

func _on_enter(_args):
	target.movement_speed = state_speed
	_pick_next_move()

func _on_update(_delta):
	# if we've reached our desired point
	if nav_agent.is_navigation_finished():
		# chase checks if we can engage; if not, it transitions back to this state
		change_state("Chase")
	
func _pick_next_move():
	var enemy_position : Vector2 = target.global_position
	var player_position : Vector2 = target.follow_object.global_position
	var player_distance : float = player_position.distance_to(enemy_position)
	# if player is within personal bubble, then walk backwards to desired_distance away
	if player_distance < personal_bubble_radius:
		# desired location is straight backward --- eventually +- 20degrees, not impl. yet
		var desired_location = player_position.direction_to(enemy_position).normalized()
		desired_location = desired_location * desired_distance
		target.set_movement_goal(target.to_global(desired_location))
	# else, player is outside of personal bubble, so do dynamic movement instead
	else:
		# desired location a point on circle of radius=desired_distance from player
		var angle_relative_player = player_position.angle_to_point(enemy_position)
		var coin_flip = randi_range(0, 1)
		var angle_shift : float
		
		match coin_flip:
			0:
				angle_shift = -0.349066 # 20 degrees in radians
			1:
				angle_shift = 0.349066
		
		var new_angle : float = angle_relative_player + (angle_shift)
		var new_pos : Vector2 = player_position.from_angle(new_angle) * desired_distance
		target.set_movement_goal(target.follow_object.to_global(new_pos))
