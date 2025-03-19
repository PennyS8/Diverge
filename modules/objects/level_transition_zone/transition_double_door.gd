extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String

func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
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
