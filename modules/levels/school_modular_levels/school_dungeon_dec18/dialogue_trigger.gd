extends Area2D

var player

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(1)
	await timer.timeout
	player = LevelManager.player
	if(player.dialogue_tracker["closet"] == false):
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "hiding_away", [self])
		player.dialogue_tracker["closet"] = true
func _on_body_exited(body: Node2D) -> void:
	self.queue_free()
