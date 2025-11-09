@tool
extends StateSound

var yarn_controller = preload("res://modules/status_effects/yarn_controller.tscn")

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var yarn = yarn_controller.instantiate()
	var dir : Vector2
	# Rotate the yarn projectile toward the mouse
	if ControllerChecker.using_gamepad:
		var aim = Input.get_vector("rstick_left", "rstick_right", "rstick_up", "rstick_down")
		if aim.length() > 0.5:
			dir = aim
		else:
			dir = target.idle_dir
	else:
		var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
		dir = target.global_position.direction_to(mouse_pos).normalized()
	yarn.rotation = Vector2.ZERO.angle_to_point(dir)
	yarn.position.y -= 8
	
	target.add_child(yarn)
