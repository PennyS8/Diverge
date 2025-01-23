@tool
extends StateSound

@onready var status_holder = $"../../../StatusHolder"
@onready var yarn_raycast = $"../../../YarnRayCast2D"

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var player_pos = target.global_position
	var anchor_body = _args
	var end_point = player_pos.lerp(anchor_body.global_position, 0.7)
	
	var tween = get_tree().create_tween()
	tween.tween_property(target, "global_position", end_point, 0.2)
	
	anchor_body.get_node("StatusHolder").remove_status("tethered")
	
	change_state("CanAttack")
	change_state("Idle")
