@tool
extends State

@export var strafe_factor := 0.25
var target_angle

# Hopefully we enter backpedal before here, but in case we don't,
# Then transition off of this timer
var fallback_attack_timer = randf_range(2.0, 4.0)

func _on_enter(_args) -> void:
	target.ai_steering.apply_strafe(_args, strafe_factor)
	target.ai_steering.apply_seek(_args, 0.15)

func _on_update(_delta: float) -> void:
	fallback_attack_timer -= _delta
