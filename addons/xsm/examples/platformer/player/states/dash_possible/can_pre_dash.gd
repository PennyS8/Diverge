@tool
extends State


signal pre_dashed


func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("pre_dashed")
