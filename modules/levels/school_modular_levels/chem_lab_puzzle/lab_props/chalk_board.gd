extends Node2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")

var open : bool
func _unhandled_input(_event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		if get_tree().current_scene.get_node_or_null("DialogueBalloon"):
			return
			
		if LevelManager.player.dialogue_open:
			return
			
		player.dir = Vector2.ZERO
		
		if !LevelManager.player.dialogue_open:
			LevelManager.player.dialogue_open = true
			var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
			DialogueManager.show_dialogue_balloon(dialogue, "instructions")
		
		get_viewport().set_input_as_handled()

func _on_chalk_board_body_entered(_body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_chalk_board_body_exited(_body: Node2D) -> void:
	interactable = false
	$Glint.hide()
