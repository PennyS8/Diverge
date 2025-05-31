extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu_inventory"):
		if visible:
			hide()
		else:
			show()
			LevelManager.player.check_unlock_hook()
	if _event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
			get_viewport().set_input_as_handled()
			
