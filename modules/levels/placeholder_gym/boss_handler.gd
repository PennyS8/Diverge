extends Node2D

@export var time_limit = 5.0
var timer_started : bool = false
var boss_dead = false

func _process(delta: float) -> void:
	
	var boss = get_tree().get_first_node_in_group("boss")
	if !boss and !boss_dead:
		boss_dead = true
		start_timer()
		$"../EntranceDialogue".queue_free()
	
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
