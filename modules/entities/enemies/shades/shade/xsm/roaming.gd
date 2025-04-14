@tool
extends State

@onready var agro_region : Area2D = $"../../AgroRegion"
@onready var movement_target_pos : Vector2
@export var nav_agent : NavigationAgent2D
@export var movement_speed : float = 25

var roam_timer : Timer

func _on_enter(_args) -> void:
	_roam_timer()
	nav_agent.target_desired_distance = 10
	nav_agent.path_desired_distance = 20

func _on_update(_delta: float) -> void:
	if agro_region.monitoring:
		var possible_follow_targets = agro_region.get_overlapping_bodies()
		for follow_target in possible_follow_targets:
			if follow_target.is_in_group("player"):
				target.follow_target = follow_target
				change_state("Alerted")
	
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
	roam_timer = Timer.new()
	add_child(roam_timer)
	roam_timer.wait_time = random_time
	roam_timer.one_shot = true
	roam_timer.start()
	roam_timer.timeout.connect(_roam_random)
	
func _roam_random():
	var x = randi_range(-24, 24)
	var y = randi_range(-24, 24)
	var goal = NavigationServer2D.map_get_closest_point(nav_agent.get_navigation_map(), target.to_global(Vector2(x,y)))
	nav_agent.target_position = goal
	_roam_timer()

func _on_exit(_args) -> void:
	roam_timer.queue_free()
