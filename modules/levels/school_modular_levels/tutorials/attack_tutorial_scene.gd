extends Node2D

#@onready var shade = $ComplexShade
#@onready var player = get_tree().get_first_node_in_group("player")
#
#var read : bool = false
#
#func _physics_process(delta: float) -> void:
	#pass
	#if !player or !shade or read:
		#return
	#elif player.global_position.distance_to(shade.global_position) <= 48:
		#read = true
		#LevelManager.enter_tutorial("AttackTutorial")
