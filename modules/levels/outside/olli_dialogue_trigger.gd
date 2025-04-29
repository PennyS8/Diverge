extends Area2D

@onready var spike_list = $"../Spikes".get_children()
var player
var olli
var accessed = false

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(accessed == false):
		player = LevelManager.player
		olli = $"../Olli"
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "start", [self])
		accessed = true
	else:
		pass
