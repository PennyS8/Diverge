@tool
extends StateSound

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

@onready var agro_region : Area2D = $"../../../AgroRegion"

@onready var movement_target_pos : Vector2
@export var nav_agent : NavigationAgent2D
@export var movement_speed : float = 25
# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	_roam_timer()

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	var possible_follow_targets = agro_region.get_overlapping_bodies()
	for follow_target in possible_follow_targets:
		if follow_target.is_in_group("player"):
			target.follow_target = follow_target
			change_state("Seeking")
	
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = target.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	target.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	target.move_and_slide()

func _roam_timer():
	# randomize timer 2-5 seconds
	# pick random location within 32 pixels
	# walk to it
	var random_time = randf_range(2, 4)
	var roam_timer = get_tree().create_timer(random_time)
	roam_timer.timeout.connect(_roam_random)
	
func _roam_random():
	var x = randi_range(-24, 24)
	var y = randi_range(-24, 24)
	var goal = NavigationServer2D.map_get_closest_point(nav_agent.get_navigation_map(), target.to_global(Vector2(x,y)))
	nav_agent.target_position = goal
	_roam_timer()

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
