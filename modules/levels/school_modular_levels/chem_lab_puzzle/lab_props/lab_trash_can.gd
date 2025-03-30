extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var chem_inventory = %ChemInventory

func _unhandled_input(_event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		if get_tree().current_scene.get_node_or_null("DialogueBalloon"):
			return
		if LevelManager.player.dialogue_open:
			return
		get_viewport().set_input_as_handled()
		player.dir = Vector2.ZERO
		
		var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
		
		var dialogue_type
		if chem_inventory.lab_inventory.count_all_items() == { }:
			dialogue_type = "no_materials_trash"
		else:
			dialogue_type = "trash"
		
		if !LevelManager.player.dialogue_open:
			LevelManager.player.dialogue_open = true
			print("Showing dialogue!:" + dialogue_type)
			DialogueManager.show_dialogue_balloon(dialogue, dialogue_type, [chem_inventory])



func _on_trash_body_entered(_body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_trash_body_exited(_body: Node2D) -> void:
	interactable = false
	$Glint.hide()
