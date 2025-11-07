@tool
extends BTCondition

@export var detection_range: float = 300.0
@export var field_of_view: float = 90.0
@export var target_group: String = "player"

func _generate_name() -> String:
	return "CanSeeTarget range: %.0f FOV: %.0f°" % [detection_range, field_of_view]

func _tick(p_delta: float) -> Status:
	var player = blackboard.get_var("target")
	if not player:
		# Try to find player
		var players = agent.get_tree().get_nodes_in_group(target_group)
		if players.is_empty():
			return FAILURE
		player = players[0]
		blackboard.set_var("target", player)
	
	var distance = agent.global_position.distance_to(player.global_position)
	if distance > detection_range:
		return FAILURE
	
	# Check field of view
	var to_player = (player.global_position - agent.global_position).normalized()
	var forward = Vector2.from_angle(agent.rotation)
	var angle = rad_to_deg(forward.angle_to(to_player))
	
	if abs(angle) <= field_of_view / 2.0:
		# Optional: Add raycast check for line of sight
		blackboard.set_var("last_known_position", player.global_position)
		return SUCCESS
	
	return FAILURE
