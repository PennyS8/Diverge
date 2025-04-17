@tool
extends State

func _on_enter(_args) -> void:
	target.unhandled_input_received.connect(state_unhandled_input)

func state_unhandled_input(event : InputEvent):
	if Input.is_action_just_pressed("deep_breath"):
		print("cope engaged")
		change_state("DeepBreath")
		get_viewport().set_input_as_handled()

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass

func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
