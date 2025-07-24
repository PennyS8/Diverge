extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String

# for playtesting
@export var puzzle_door : bool
@export var anti_key : ItemLike

@export var locked : bool
@export_file("*.dialogue") var locked_dialogue_file
@export var locked_dialogue_name : String

var inv : Inventory

var encounter_active

@onready var sfx_player = $AudioStreamPlayer2D

func _ready():
	if GameManager.inventory_node:
		inv = GameManager.inventory_node.inventory
	
	LevelManager.enter_encounter.connect(encounter_state.bind(true))
	LevelManager.exit_encounter.connect(encounter_state.bind(false))
	
func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		if puzzle_door:
			if check_books():
				player.dir = Vector2.ZERO
				var dialogue = load("res://modules/levels/school_modular_levels/Playtest/playtest_dialogue.dialogue")
				DialogueManager.show_dialogue_balloon(dialogue, "puzzle_complete")
			else:
				$AudioStreamPlayer2D.play()
				LevelManager.change_level(next_level_path, entrance_name)
		elif locked:
			player.dir = Vector2.ZERO
			var dialogue = load(locked_dialogue_file)
			DialogueManager.show_dialogue_balloon(dialogue, locked_dialogue_name)
		else:
			LevelManager.change_level(next_level_path, entrance_name)
		get_viewport().set_input_as_handled()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if encounter_active:
		return
	
	interactable = true
	$Glint.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	interactable = false
	$Glint.hide()

func encounter_state(state):
	var blocker = $Blocker
	match state:
		true:
			blocker.process_mode = Node.PROCESS_MODE_INHERIT
			blocker.show()
			encounter_active = true
		false:
			blocker.process_mode = Node.PROCESS_MODE_DISABLED
			blocker.hide()
			encounter_active = false

func check_books():
	if !inv:
		inv = GameManager.inventory_node.inventory
	
	if InventoryHelper.is_itemtype_in_inventory(inv, anti_key):
		return true
	else: return false
