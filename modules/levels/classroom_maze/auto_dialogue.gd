extends Node2D

func _on_dialogue_body_entered(body: Node2D) -> void:
	var dialogue = load("res://modules/levels/classroom_maze/anxious_classroom.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	self.queue_free()
