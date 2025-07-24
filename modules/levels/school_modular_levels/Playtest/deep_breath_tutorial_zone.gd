extends Area2D

var read : bool = false

func _on_body_entered(body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player.dialogue_tracker["deep_breath_practice"]:
		return
	
	player.dialogue_tracker["deep_breath_practice"] = true
	
	var dialogue = load("res://modules/levels/school_modular_levels/tutorials/tutorials.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "deep_breath_tutorial")
