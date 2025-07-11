@tool
extends State

func _on_enter(_args):
	target.unhandled_input_received.connect(state_unhandled_input)

func _on_update(_delta):
	pass

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

func _after_update(_delta):
	target.move_and_slide()

func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
