@tool
extends State


signal pre_jumped


func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("pre_jumped")
