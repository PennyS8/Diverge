@tool
extends State

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	pass

func _on_update(_delta):
	target.dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("override_push"):
		change_state("Push")
	elif Input.is_action_just_pressed("override_fall"):
		change_state("Fall")
	elif Input.is_action_just_pressed("override_drop"):
		change_state("Drop")
	
	elif Input.is_action_just_pressed("lasso"):
		# Prevents the player from lassoing when 2 entities are already tethered
		var prev_tethered = $"/root/StatusEffectsManager".num_tethered_entities()
		if prev_tethered < 2:
			change_state("Lasso")
	elif Input.is_action_just_pressed("throw"):
		change_state("Aim")
	elif Input.is_action_just_pressed("recall"):
		change_state("Recall")

func _after_update(_delta):
	# target.velocity = target.move_and_slide(target.velocity, Vector2.UP)
	target.move_and_slide()
	
