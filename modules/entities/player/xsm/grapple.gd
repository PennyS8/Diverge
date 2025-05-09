@tool
extends StateSound

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var player_pos = target.global_position
	var anchor_body = _args
	var end_point = player_pos.lerp(anchor_body.global_position, 0.7)
	
	var tween = get_tree().create_tween()
	tween.tween_property(target, "global_position", end_point, 0.2)
	
	change_state("CanAttack")
	change_state("Idle")
