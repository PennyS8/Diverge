@tool
extends StateSound

var idle_dir : Vector2
var idle_states : Dictionary = {
	Vector2.UP: "idle_up",
	Vector2.LEFT: "idle_left",
	Vector2.RIGHT: "idle_right",
	Vector2.DOWN: "idle_down"
}

func _on_enter(_args):
	if !target.in_cutscene:
		change_state("CanAttack")
	
	var no_hook = ""
	if target.hook_locked:
		no_hook = "no_spear/"
	
	if(_args):
		idle_dir = _args
	else:
		idle_dir = Vector2.DOWN
	
	play_blend(no_hook + idle_states[idle_dir], 0.0)

func _on_update(_delta):
	if target.dir != Vector2.ZERO:
		change_state("Walk")
	
	var no_hook = ""
	if target.hook_locked:
		no_hook = "no_spear/"
	
	play(no_hook + idle_states[idle_dir])
