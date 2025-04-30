extends Area2D

@onready var spike_list = $"../Spikes".get_children()

var player
var olli

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	player = LevelManager.player
	if(player.dialogue_tracker["boss_battled"] == false && player.dialogue_tracker["end_scene"] == false):
		olli = $"../Olli"
		olli.show()
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "end_convo", [self])
		player.dialogue_tracker["end_scene"] == true
