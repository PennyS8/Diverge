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
	
	# Take the direction the player is facing and lock it to a cardinal 
	var component_x = abs(death_dir.x)
	var component_y = abs(death_dir.y)
	if component_x >= component_y:
		death_dir.y = 0
	else:
		death_dir.x = 0
	death_dir = death_dir.snapped(Vector2.ONE)
	
	change_state(death_states[death_dir])

func change_to_next_substate():
	RespawnManager.respawn()
