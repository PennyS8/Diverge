extends Area2D

var read : bool = false
@onready var player = get_tree().get_first_node_in_group("player")

func _on_body_entered(_body: Node2D) -> void:
	if read: # Don't allow this dialogue to be read more than once
		return
	
	read = true # TODO: "read" must be saved by the save&load manager
	# By defulat this dialogue should be reset every time you leave the room
	# and return. EXCEPT, in the case the puzzle has already been solved; in
	# this case, save var "read" as true.
	
	player.dir = Vector2.ZERO
	var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
	# Additionally you can add a dialogue for when the puzzle has been solved to
	# indicate to the player there is nothing more for them here.
	# i.e., "Dammit! I forgot what I was doing again. I already [insert task completed in this puzzle],
	# better retrace my steps and try to remember what I was doing."
	DialogueManager.show_dialogue_balloon(dialogue, "entrance")
	
