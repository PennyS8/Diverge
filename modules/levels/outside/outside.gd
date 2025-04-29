extends Node2D

@onready var spike_list = $Spikes.get_children()
var player
var olli

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(1)
	await timer.timeout
	player = LevelManager.player
	olli = $Olli
	DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "start", [self])
	
	await DialogueManager.dialogue_ended
	LevelManager.player_transition(
		"res://modules/levels/school_modular_levels/tutorials/attack_tutorial_scene.tscn", 
		Vector2.ZERO,
		"0")
