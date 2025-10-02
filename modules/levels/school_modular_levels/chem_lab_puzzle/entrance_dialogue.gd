extends Area2D

var read : bool = false
@onready var player = get_tree().get_first_node_in_group("player")

#region Savegame
func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
#endregion

func _on_body_entered(_body: Node2D) -> void:
	if read: # Don't allow this dialogue to be read more than once
		return
	
	read = true # TODO: "read" must be saved by the save&load manager
	# By defulat this dialogue should be reset every time you leave the room
	# and return. EXCEPT, in the case the puzzle has already been solved; in
	# this case, save var "read" as true.
	
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
		
		if !param:
			return
	# Additionally you can add a dialogue for when the puzzle has been solved to
	# indicate to the player there is nothing more for them here.
	# i.e., "Dammit! I forgot what I was doing again. I already [insert task completed in this puzzle],
	# better retrace my steps and try to remember what I was doing."
	DialogueManager.show_dialogue_balloon(dialogue, dialogue_type, [param])
	
