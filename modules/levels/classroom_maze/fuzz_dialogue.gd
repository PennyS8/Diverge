extends Area2D

@onready var playerNoise

func _on_body_entered(body: Node2D) -> void:
	body.dir = Vector2.ZERO
	if !playerNoise:
		playerNoise = LevelManager.player.get_node("stressEffect")
	playerNoise.show()
	var dialogue = load("res://modules/levels/classroom_maze/anxious_classroom.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "fuzz")
	self.queue_free()
