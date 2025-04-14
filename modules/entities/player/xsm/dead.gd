@tool
extends StateAnimation

func _on_enter(_args) -> void:
	change_state("NoAttack")
