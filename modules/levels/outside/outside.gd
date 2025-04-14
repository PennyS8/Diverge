extends Node2D

@onready var spike_list = $Spikes.get_children()
var player

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(1)
	await timer.timeout
	player = LevelManager.player
	DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "hiding_away", [self])
