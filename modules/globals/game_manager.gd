extends Node

var inventory_node : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("left_click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			return
	pass
