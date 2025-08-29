extends StaticBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var book : ItemLike
var inv

func _on_area_2d_body_entered(body):
	# If we have the book we no longer want to prevent player from leaving.
	if inv.has(book):
		return
	
	var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
	
	LevelManager.player.dir = Vector2.ZERO
	DialogueManager.show_dialogue_balloon(dialogue, "no_exit", [self])

func check_book():
	if !inv:
		inv = GameManager.inventory_node.inventory
	
	## TODO: Get this to check for a single book
	#var all_counts = inv.count_all_items()
	#for book in keys_needed:
		#if !all_counts.has(key):
			#return false
		#if all_counts[key] < 1:
			#return false
	#return true
