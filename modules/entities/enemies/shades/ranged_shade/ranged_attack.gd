@tool
extends StateAnimation

@onready var agro_region : Area2D = $"../../AgroRegion"

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

@export var projectile_scene : PackedScene

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	var shot_loc = _args
	var parent_loc : Vector2 = target.global_position + Vector2(0, -12)
	var projectile_rotation = parent_loc.angle_to_point(shot_loc)
	
	var proj : Area2D = projectile_scene.instantiate()
	proj.rotate(projectile_rotation)
	proj.global_position = target.global_position + Vector2(0, -12)
	get_tree().current_scene.add_child(proj)
	
	#target.modulate = Color.WHITE

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	var player_found := false
	#var overlaps = agro_region.get_overlapping_bodies()
	var possible_follow_targets = agro_region.get_overlapping_bodies()
	for follow_target in possible_follow_targets:
		if follow_target.is_in_group("player"):
			player_found = true
			
	# If player's not inside AgroRegion, transition back to Roaming
	if !player_found:
		change_state("Roaming")
	else:
		change_state("Seeking")


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
