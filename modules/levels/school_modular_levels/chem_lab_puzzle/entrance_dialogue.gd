extends Area2D

var read : bool = false
@onready var player = get_tree().get_first_node_in_group("player")

func _on_body_entered(_body: Node2D) -> void:
	if read: # Don't allow this dialogue to be read more than once
		return
	
	read = true # TODO: "read" must be saved by the save&load manager
	# This dialogue should be reset every time you leave the room and return
	# EXCEPT, in the case the puzzle has already been solved
	
	player.dir = Vector2.ZERO
	var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "entrance")
