@tool
extends State

@export var nav_agent : NavigationAgent2D
@export var movement_speed : float
@export var STEER_SPEED : float
@export var MAX_SPEED : float
@onready var movement_target_pos : Vector2

@export_group("Behavioral Variables")
@export_range(0.0,40.0, 0.25) var backstep_random_mintime : float
@export_range(0.0,40.0, 0.25) var backstep_random_maxtime : float

var backstep_timer : Timer
var offset_vector : Vector2
# FUNCTIONS TO INHERIT IN YOUR STATES
#
# Code related to nav_agent & tilemap integration are inspired by: 
# "Shifty the Dev"
# https://blog.shiftythedev.com/posts/GodotTilemapNavigation/
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	target.velocity = Vector2.ZERO
	#var random_rad = deg_to_rad(randi_range(0,360))
	#var random_vec_x = cos(random_rad)
	#var random_vec_y = sin(random_rad)
	#offset_vector = Vector2(random_vec_x, random_vec_y).normalized() * 24.0

	nav_agent.target_desired_distance = 24
	nav_agent.path_desired_distance = 10

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass
	
func set_movement_target(target_pos: Vector2):
	nav_agent.target_position = target_pos

func get_nearest_edible_ramen():
	var ramens = get_tree().get_nodes_in_group("edible_ramen")
	
	if ramens == []:
		return null
	
	var nearest_ramen = ramens[0]
	var nearest_distance = target.global_position.distance_squared_to(nearest_ramen.global_position)
	
	# Find the nearest ramen
	for ramen in ramens:
		var distance = target.global_position.distance_squared_to(ramen.global_position)
		if distance < nearest_distance:
			nearest_ramen = ramen
			nearest_distance = distance
	return nearest_ramen
	
# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	target.follow_target = get_nearest_edible_ramen()
	
	if !target.follow_target:
		target.follow_target = get_nearest_edible_ramen()

		
	movement_target_pos = target.follow_target.global_position
	set_movement_target(movement_target_pos)
	
	if nav_agent.is_navigation_finished():
		target.velocity = Vector2.ZERO

	
	var current_agent_position: Vector2 = target.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	var desired_velocity = current_agent_position.direction_to(next_path_position) * movement_speed

	target.velocity = target.velocity.lerp(desired_velocity, 0.035).normalized()
	target.velocity *= movement_speed
	
	target.move_and_slide()
