extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu_inventory"):
		if visible:
			hide()
		else:
			show()
			LevelManager.player.check_unlock_hook()
