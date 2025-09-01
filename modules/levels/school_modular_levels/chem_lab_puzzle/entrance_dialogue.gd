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
	
	# Only prevents player from leaving once they are aware of the book in the room
	%ExitDialogue.set_collision_mask_value(1, true)
	%ExitDialogue.set_collision_layer_value(1, true)
	%ExitDialogue/Area2D.set_collision_mask_value(3, true)
	
	player.dir = Vector2.ZERO
	
	var dialogue
	var dialogue_type
	var param
	if LevelManager.current_level.name == "ChemLabPuzzle":
		dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
		dialogue_type = "entrance"
	elif LevelManager.current_level.name == "SchoolGym":
		dialogue = load("res://modules/dialogue/demo_scenes.dialogue")
		dialogue_type = "gym_battle"
		param = get_tree().get_first_node_in_group("boss")
	# Additionally you can add a dialogue for when the puzzle has been solved to
	# indicate to the player there is nothing more for them here.
	# i.e., "Dammit! I forgot what I was doing again. I already [insert task completed in this puzzle],
	# better retrace my steps and try to remember what I was doing."
	DialogueManager.show_dialogue_balloon(dialogue, dialogue_type, [param])
	
