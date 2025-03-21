extends StaticBody2D

var interactable : bool = false
var puzzle_complete : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var chem_inventory = %ChemInventory

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.parent_node_path = get_parent().get_path()
	my_data.puzzle_completed = puzzle_complete
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	puzzle_complete = saved_data.puzzle_completed

func _unhandled_input(_event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		
		if chem_inventory.stations["book"] == 1:
			puzzle_complete = true
		
		var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
		
		var dialogue_type
		if puzzle_complete == true:
			dialogue_type = "puzzle_completed"
		elif chem_inventory.lab_inventory.count_all_items() == { }:
			dialogue_type = "no_materials"
		elif chem_inventory.lab_inventory.items.size() == 1:
			dialogue_type = "one_material_mixer"
		elif chem_inventory.stations["scale"] == 0:
			dialogue_type = "not_measured"
		else: 
			dialogue_type = "mixer"
			
		DialogueManager.show_dialogue_balloon(dialogue, dialogue_type, [chem_inventory])
		
		get_viewport().set_input_as_handled()

func _on_mixer_body_entered(_body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_mixer_body_exited(_body: Node2D) -> void:
	interactable = false
	$Glint.hide()
