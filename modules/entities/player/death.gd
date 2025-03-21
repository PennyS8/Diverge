@tool
extends StateSound

var death_states : Dictionary = {
	Vector2.UP: "DeathUp", 
	Vector2.RIGHT: "DeathRight",
	Vector2.DOWN: "DeathDown",
	Vector2.LEFT: "DeathLeft"
	}

func _on_enter(_args) -> void:
	change_state("NoAttack")
	change_state("NoDash")
