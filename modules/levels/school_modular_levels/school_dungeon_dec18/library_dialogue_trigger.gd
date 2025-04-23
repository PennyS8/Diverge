extends Area2D

@onready var spike_list = $"../JuniperSpikes".get_children()

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
	if(player.dialogue_tracker["library"] == false):
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "library_entry", [self])
		player.dialogue_tracker["library"] = true
