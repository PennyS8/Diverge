extends Node2D

var read : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if read:
		return
	read = true
	
	var dialogue = load("res://modules/levels/school_modular_levels/tutorials/tutorials.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "deep_breath_tutorial")
	
