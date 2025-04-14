@tool
extends StateSound

func _on_enter(_args) -> void:
	change_state("NoAttack")
	play_sound()
	
	var player_pos = target.global_position
	var anchor_body = _args
	var end_point = player_pos.lerp(anchor_body.global_position, 0.7)
	
	var tween = get_tree().create_tween()
	tween.tween_property(target, "global_position", end_point, 0.2)
	
	change_state("CanAttack")
	change_state("Idle")
