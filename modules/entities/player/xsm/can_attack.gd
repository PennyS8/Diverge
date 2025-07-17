@tool
extends State

func _on_enter(_args) -> void:
	target.unhandled_input_received.connect(state_unhandled_input)

func state_unhandled_input(_event : InputEvent):
	if is_active("MovementDisabled"):
		return
	
	if Input.is_action_just_pressed("attack_melee"):
		change_state("AttackMelee")

func _before_exit(_args) -> void:
	target.unhandled_input_received.disconnect(state_unhandled_input)
