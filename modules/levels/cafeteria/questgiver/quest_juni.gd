extends StaticBody2D


func _on_interaction_circle_body_entered(body: Node2D) -> void:
	body.dir = Vector2.ZERO
	var dialogue = load("res://modules/levels/cafeteria/questgiver/juni_hungry.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "start")
