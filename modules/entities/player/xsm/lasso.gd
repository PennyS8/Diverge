@tool
extends StateSound


# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	change_state("ModeDisabled")
	
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var attack_dir = target.global_position.direction_to(mouse_pos).normalized()
	$"../../../Thread".rotation = Vector2(0, 0).angle_to_point(attack_dir)
	

func _on_exit(_args) -> void:
	change_state("ModeSnap")
	change_state("CanAttack")
