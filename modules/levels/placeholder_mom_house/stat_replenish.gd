extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# NATE: I added this await line because if we run this from 
	if get_tree().current_scene.name != "Main":
		await LevelManager.main_ready
	var player = get_tree().get_first_node_in_group("player")
	
	# Gets how much health the player has lost
	var heal_amount = player.health_component.max_health - player.health_component.health
	
	# Fully heals the player
	player.health_component.heal(heal_amount)
