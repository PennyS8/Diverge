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
	
	var dist = target.global_position.distance_to(target.follow_target.global_position) / movement_speed
	movement_target_pos = target.follow_target.to_global(target.follow_target.velocity) * dist
	movement_target_pos += offset_vector

	nav_agent.target_desired_distance = 24
	nav_agent.path_desired_distance = 10
	
	var rng : float = randf_range(backstep_random_mintime, backstep_random_maxtime)
	backstep_timer = Timer.new()
	backstep_timer.one_shot = true
	backstep_timer.timeout.connect(_backstep_timeout, CONNECT_ONE_SHOT)
	backstep_timer.wait_time = rng
	backstep_timer.autostart = true
	target.add_child(backstep_timer)

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

func _backstep_timeout() -> void:
	change_state("Backstep")
	
func set_movement_target(target_pos: Vector2):
	nav_agent.target_position = target_pos


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if !target.follow_target:
		change_state("Roaming")
		
	movement_target_pos = target.follow_target.to_global(target.follow_target.velocity * 0.2)
	movement_target_pos += offset_vector
	set_movement_target(movement_target_pos)
	
	if nav_agent.is_navigation_finished():
		change_state("ChargeAttack")
	
	var current_agent_position: Vector2 = target.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	var desired_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	# debug raycast display
	$"../../Display/DebugDesiredVelocity".target_position = desired_velocity
		
	target.velocity = target.velocity.lerp(desired_velocity, 0.035).normalized()
	target.velocity *= movement_speed
	$"../../Display/DebugActualVelocity".target_position = target.velocity
	target.move_and_slide()

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
	backstep_timer.queue_free()


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
