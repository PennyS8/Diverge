extends Node2D

@onready var shade = $ComplexShade
@onready var player = get_tree().get_first_node_in_group("player")
@onready var dialogue = load("res://modules/levels/school_modular_levels/tutorials/melee_attack_tutorial.dialogue")

var read : bool = false

func _physics_process(delta: float) -> void:
	if !player or !shade or read:
		return
	elif player.global_position.distance_to(shade.global_position) <= 48:
		read = true
		
		#DialogueManager.show_dialogue_balloon(dialogue, "start")
		LevelManager.enter_tutorial("AttackTutorial")
