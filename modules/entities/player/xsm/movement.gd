@tool
extends State

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	target.unhandled_input_received.connect(state_unhandled_input)

func _on_update(_delta):
	pass
	#if Input.is_action_just_pressed("override_push"):
		#change_state("Push")
	#elif Input.is_action_just_pressed("override_fall"):
		#change_state("Fall")
	#elif Input.is_action_just_pressed("override_drop"):
		#change_state("Drop")
	#elif Input.is_action_just_pressed("recall"):
			#change_state("Recall")

func state_unhandled_input(event : InputEvent):
	if is_active("MovementDisabled") or target.in_cutscene:
		return
	if event is InputEventAction:
		if event.is_action_just_pressed("override_push"):
			change_state("Push")
		elif event.is_action_just_pressed("override_fall"):
			change_state("Fall")
		elif event.is_action_just_pressed("override_drop"):
			change_state("Drop")
		elif event.is_action_just_pressed("recall"):
			change_state("Recall")

func _after_update(_delta):
	target.move_and_slide()
	
func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
