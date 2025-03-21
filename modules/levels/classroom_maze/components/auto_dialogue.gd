extends Area2D

var iteration = 0

@onready var playerNoise
var dialogue = load("res://modules/levels/classroom_maze/anxious_classroom.dialogue")

func _on_body_entered(body: Node2D) -> void:
	if !playerNoise:
		playerNoise = LevelManager.player.get_node("stressEffect")
	body.dir = Vector2.ZERO
	match iteration:
		0:
			DialogueManager.show_dialogue_balloon(dialogue, "start")
		1:
			playerNoise.hide()
			DialogueManager.show_dialogue_balloon(dialogue, "complete")
			self.queue_free()
	iteration = iteration + 1
