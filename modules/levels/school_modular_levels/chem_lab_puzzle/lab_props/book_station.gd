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
	if saved_data.puzzle_completed == true:
		remove_book()

func _unhandled_input(_event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		get_viewport().set_input_as_handled()

		player.dir = Vector2.ZERO
		var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
		
		var substance = ""
		if chem_inventory.lab_inventory.get_item_at_positionv(Vector2(0,0)) != null:
			substance = chem_inventory.lab_inventory.get_item_at_positionv(Vector2(0,0)).item_type.name
		
		var dialogue_type
		if puzzle_complete == true:
			dialogue_type = "puzzle_completed"
		elif substance == "Olive Substance":
			dialogue_type = "grab_book"
			remove_book()
		else: 
			dialogue_type = "book"
		
		DialogueManager.show_dialogue_balloon(dialogue, dialogue_type, [chem_inventory])
		

func _on_book_body_entered(_body: Node2D) -> void:
	interactable = true
	if puzzle_complete == false:
		$Glint.show()

func _on_book_body_exited(_body: Node2D) -> void:
	interactable = false
	if puzzle_complete == false:
		$Glint.hide()

func remove_book():
	$Book.hide()
	$Glint.hide()
	puzzle_complete = true
	chem_inventory.station_complete("book")
