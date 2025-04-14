@tool
extends State

@export var chase_speed := 60.0
var target_angle
@export var strafe_factor := 0.25

func _on_enter(_args) -> void:
	if !_args:
		return
	
	target.movement_speed = chase_speed
	target.ai_steering.apply_seek(_args)
	target.ai_steering.apply_strafe(_args, strafe_factor)
