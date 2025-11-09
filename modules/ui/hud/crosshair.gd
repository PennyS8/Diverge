extends Sprite2D

## Defines when the cursor can move freely (aka emulating a mouse with gamepad).
## This is useful mainly for deep breath mechanic as of right now.
var free_movement := true

func _input(event):
	# restrict movement while free movement is false. when its true, emulate a mouse.
	if event is InputEventMouseMotion:
		# Despite this check, it's currently invisible while using mouse.
		global_position = get_global_mouse_position()
	elif event is InputEventJoypadMotion:
		var aim = Input.get_vector("rstick_left", "rstick_right", "rstick_up", "rstick_down")
		position = aim * 64.0
