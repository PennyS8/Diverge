@tool
extends StateSound

# dictionary allows us to get which attack state to get from which cardinal
# our mouse is closest to
var hop_states : Dictionary = {
	Vector2.UP: "HopUp",
	Vector2.LEFT: "HopLeft",
	Vector2.RIGHT: "HopRight",
	Vector2.DOWN: "HopDown"
	}

# used for calculating hook swing direction (up, down, left right)
# as well as nudge direction (360deg)
var hop_dir : Vector2
var hop_pos : Vector2
var is_pitfall : bool
var start_pos : Vector2
# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	if _args:
		hop_dir = _args[0]
		hop_pos = _args[1]
		is_pitfall = _args[2]
	else:
		hop_dir = Vector2.DOWN
		hop_pos = Vector2.ZERO
		is_pitfall = false
		printerr("_args not implemented in calling function")
	change_state("NoAttack")
	change_state("NoDash")

	start_pos = target.global_position
	
	var pos_tween = target.create_tween()
	pos_tween.tween_property(target, "global_position", target.global_position+hop_pos, 0.5).set_trans(Tween.TRANS_QUAD)
	pos_tween.finished.connect(check_pitfall)
	# our four cardinals are:
	# UP: (0,-1)
	# RIGHT: (1,0)
	# DOWN: (0, 1)
	# LEFT: (-1, 0)
	# the dictionary initialized at the top of this script assigns each vector2
	# value to the corresponding state node name
	change_state(hop_states[hop_dir])

# on tween finished (aka when we're at our end position)
# we check if we passed in is_pitfall
# if so, we transition to "Fall" state
func check_pitfall():
	if is_pitfall:
		change_state("Fall", start_pos)
	else:
		change_state("Idle")

# pretty much same logic as dash for these two functions.
func _on_update(_delta):
	pass

# Need to change the state back to "CanDash" as we change to the "NoDash" state upon entry
func _on_exit(_args):
	change_state("CanDash")
