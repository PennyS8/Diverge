extends Node2D

@export var time_limit = 5.0
var timer_started : bool = false

func _process(delta: float) -> void:
	if !timer_started:
		return
	
	time_limit -= delta
	
	if time_limit <= 0:
		timer_started = false
		var dialogue = load("res://modules/levels/placeholder_gym/gym_boss.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "boss_defeated", [self])

func start_timer():
	timer_started = true

func transition():
	var path = "res://modules/levels/school_modular_levels/school_dungeon_act_one/foyer_postboss.tscn"
	var dir = Vector2(0, 1)
	var entrance = "FoyerNorth"
	LevelManager.player_transition(path, dir, entrance)
