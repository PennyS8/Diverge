@tool
extends StateSound


# used for calculating hook swing direction (up, down, left right)
# as well as nudge direction (360deg)
var attack_dir : Vector2

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	attack_dir = target.global_position.direction_to(mouse_pos).normalized()
	$"../../../Thread".rotation = Vector2(0, 0).angle_to_point(attack_dir)
	
