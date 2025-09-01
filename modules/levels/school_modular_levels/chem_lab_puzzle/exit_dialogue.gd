extends StaticBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var book : ItemLike
var inv

func _on_area_2d_body_entered(body):
	if !inv:
		inv = GameManager.inventory_node.inventory
	
	var all_counts = inv.count_all_items()
	# If we have the book, we no longer want to prevent player from leaving
	if all_counts.has(book):
		# Removes player collision with exit barrier once player has obtained book
		%ExitDialogue.set_collision_mask_value(1, false)
		%ExitDialogue.set_collision_layer_value(1, false)
		return
	
	var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
	
	LevelManager.player.dir = Vector2.ZERO
	DialogueManager.show_dialogue_balloon(dialogue, "no_exit", [self])
