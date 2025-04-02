@tool
extends StateSound

var death_states : Dictionary = {
	Vector2.UP: "DeathUp", 
	Vector2.RIGHT: "DeathRight",
	Vector2.DOWN: "DeathDown",
	Vector2.LEFT: "DeathLeft"
	}
	
var death_dir : Vector2

func _on_enter(_args) -> void:
	change_state("NoAttack")
	change_state("NoDash")
	
	if (_args):
		death_dir = _args
	else:
		death_dir = Vector2.DOWN
	
	change_state(death_states[death_dir])
