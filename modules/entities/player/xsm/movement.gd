@tool
extends State

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	pass

func _on_update(_delta):
	target.dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("push"):
		change_state("Push")
	elif Input.is_action_just_pressed("fall"):
		change_state("Fall")

func _after_update(_delta):
	# target.velocity = target.move_and_slide(target.velocity, Vector2.UP)
	target.move_and_slide()

	#if target.velocity.x > 0:
		#target.skin.scale.x = 1
	#elif target.velocity.x < 0:
		#target.skin.scale.x = -1
