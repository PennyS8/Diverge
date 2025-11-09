extends Sprite2D

func _process(delta):
	if !ControllerChecker.using_gamepad:
		hide()
		return
	
	show()
	var cursor_dir = Input.get_vector("rstick_left", "rstick_right", "rstick_up", "rstick_down")
	global_position += cursor_dir * delta * 700.0
	var current_min_limit = get_viewport_rect()
	global_position = global_position.clamp(current_min_limit.position, current_min_limit.end)
	get_viewport().warp_mouse(position)
