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

# used for calculating sword swing direction (up, down, left right)
# as well as nudge direction (360deg)
var hop_dir : Vector2

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var mouse_pos = target.get_global_mouse_position()  
	
	hop_dir = Vector2(0, 1) # down

	# our four cardinals are:
	# UP: (0,-1)
	# RIGHT: (1,0)
	# DOWN: (0, 1)
	# LEFT: (-1, 0)
	# the dictionary initialized at the top of this script assigns each vector2
	# value to the corresponding state node name
	change_state(hop_states[hop_dir])
	
# pretty much same logic as dash for these two functions.
func _on_update(_delta):
	pass
