extends Node2D

@onready var shade = $ComplexShade
@onready var player = get_tree().get_first_node_in_group("player")

var read : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if read:
		return
	read = true
	
	var dialogue = load("res://modules/levels/school_modular_levels/tutorials/tutorials.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "deep_breath_tutorial")
	
