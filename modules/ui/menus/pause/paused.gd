extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		show()


func _on_button_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_button_2_pressed() -> void:
	get_tree().quit() # Replace with function body.
