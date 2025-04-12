extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String

# for playtesting
@export var puzzle_door : bool
@export var anti_key : ItemLike
var inv : Inventory

func _ready():
	if GameManager.inventory_node:
		inv = GameManager.inventory_node.inventory
	
func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		if puzzle_door:
			if check_books():
				var dialogue = load("res://modules/levels/school_modular_levels/Playtest/playtest_dialogue.dialogue")
				DialogueManager.show_dialogue_balloon(dialogue, "puzzle_complete")
			else:
				LevelManager.change_level(next_level_path, entrance_name)
		else:
			LevelManager.change_level(next_level_path, entrance_name)
		get_viewport().set_input_as_handled()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	interactable = false
	$Glint.hide()

func check_books():
	if !inv:
		inv = GameManager.inventory_node.inventory
	
	if InventoryHelper.is_itemtype_in_inventory(inv, anti_key):
		return true
	else: return false
