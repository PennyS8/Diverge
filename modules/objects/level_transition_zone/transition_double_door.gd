extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String

@export var keys_needed : Array[ItemLike]
func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
		return
	
	# check if we have proper keys
	var inv : Inventory = GameManager.inventory_node.inventory
	var count_dict = {}
	for item in keys_needed:
		count_dict.set(item, 1)
	if !inv.has_items(keys_needed, count_dict):
		return
	# TODO: check player inventory for 3 books
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		LevelManager.change_level(next_level_path, entrance_name)
		
		var dialogue = load("res://modules/levels/school_modular_levels/Playtest/playtest_dialogue.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "double_door")
		
		get_viewport().set_input_as_handled()

func _on_area_2d_body_entered(body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	interactable = false
	$Glint.hide()
