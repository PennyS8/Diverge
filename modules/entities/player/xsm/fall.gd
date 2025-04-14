@tool
extends StateAnimation

var start_pos : Vector2

func _on_anim_finished() -> void:
	target.global_position = start_pos
	target.health_component.damage(1)
	play("RESET")
	change_state("Idle")

func _on_enter(_args) -> void:
	if _args:
		start_pos = _args
	else:
		start_pos = Vector2.ZERO
