@tool
extends State

func _on_enter(_args) -> void:
	var tween = target.create_tween().set_parallel(true)
	var end_position = target.global_position + Vector2(randi_range(-24, 24), randi_range(24, 32))
	tween.tween_property(target, "global_position", end_position, 2.0)
