@tool
extends StateSound

var hop_states : Dictionary = {
	Vector2.UP: "HopUp",
	Vector2.LEFT: "HopLeft",
	Vector2.RIGHT: "HopRight",
	Vector2.DOWN: "HopDown"
}

var hop_dir : Vector2
var hop_pos : Vector2
var is_pitfall : bool
var start_pos : Vector2

func _on_enter(_args) -> void:
	change_state("NoAttack")
	change_state("NoDash")
	
	if _args:
		hop_dir = _args[0]
		hop_pos = _args[1]
		is_pitfall = _args[2]
	else:
		hop_dir = Vector2.DOWN
		hop_pos = Vector2.ZERO
		is_pitfall = false
		printerr("_args not implemented in calling function")
	
	start_pos = target.global_position
	
	var pos_tween = target.create_tween()
	pos_tween.tween_property(target, "global_position", target.global_position+hop_pos, 0.5).set_trans(Tween.TRANS_QUAD)
	pos_tween.finished.connect(check_pitfall)
	
	change_state(hop_states[hop_dir])

func check_pitfall():
	if is_pitfall:
		change_state("Fall", start_pos)
	else:
		change_state("Idle")

func _on_exit(_args):
	change_state("CanDash")
	change_state("CanAttack")
