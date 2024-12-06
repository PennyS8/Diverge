extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_2_pressed() -> void:
	hide()
	get_node("../Credits").show()


func _on_button_pressed() -> void:
	hide()
	get_tree().paused = false
	
