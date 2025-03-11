extends StaticBody2D


func _on_interaction_circle_body_entered(body: Node2D) -> void:
	var dialogue = load("res://modules/dialogue/dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "this_is_a_node_title")
