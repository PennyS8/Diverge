@tool
extends BTAction

@export var move_speed: float = 150.0
@export var arrival_distance: float = 80.0
@export var use_pathfinding: bool = true

var navigation_agent: NavigationAgent2D

func _setup() -> void:
	if agent.has_node("NavigationAgent2D"):
		navigation_agent = agent.get_node("NavigationAgent2D")

func _generate_name() -> String:
	return "ChaseTarget speed: %.0f" % move_speed

func _tick(p_delta: float) -> Status:
	var target = blackboard.get_var("target")
	if not target:
		return FAILURE
	
	var target_pos = target.global_position
	var distance = agent.global_position.distance_to(target_pos)
	
	if distance <= arrival_distance:
		return SUCCESS
	
	if use_pathfinding and navigation_agent:
		navigation_agent.target_position = target_pos
		if not navigation_agent.is_navigation_finished():
			var next_pos = navigation_agent.get_next_path_position()
			var direction = (next_pos - agent.global_position).normalized()
			agent.velocity = direction * move_speed
			agent.move_and_slide()
	else:
		# Simple direct movement
		var direction = (target_pos - agent.global_position).normalized()
		agent.velocity = direction * move_speed
		agent.move_and_slide()
	
	# Face movement direction
	agent.look_at(agent.global_position + agent.velocity)
	
	return RUNNING
