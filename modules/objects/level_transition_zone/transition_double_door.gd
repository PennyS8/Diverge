extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String
@export var door_name : String

var inv : Inventory
var count_dict : Dictionary
@export var keys_needed : Array[ItemLike]

func _ready():
	# check if we have proper keys
	if GameManager.inventory_node:
		inv = GameManager.inventory_node.inventory
	count_dict = {}
	for item in keys_needed:
		count_dict.set(item, 1)
		
func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
		return
	
	# TODO: check player inventory for 3 books
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		
		var dialogue = load("res://modules/levels/school_modular_levels/Playtest/playtest_dialogue.dialogue")

		if check_keys():
			you_shall_pass()
		elif door_name == "book_door":
			DialogueManager.show_dialogue_balloon(dialogue, "need_books", [self])
		elif door_name == "foyer_door":
			DialogueManager.show_dialogue_balloon(dialogue, "need_key", [self])
		elif door_name == "gym_door":
			pass
		
		get_viewport().set_input_as_handled()

func _on_area_2d_body_entered(body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	interactable = false
	$Glint.hide()
	
func check_keys():
	if !inv:
		inv = GameManager.inventory_node.inventory
	
	var all_counts = inv.count_all_items()
	for key in keys_needed:
		if !all_counts.has(key):
			return false
		if all_counts[key] < 1:
			return false
	return true
	
func you_shall_pass():
	LevelManager.player_transition(next_level_path, Vector2.UP, entrance_name)
