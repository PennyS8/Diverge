extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var chem_inventory = %ChemInventory

func _unhandled_input(_event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
		
		DialogueManager.show_dialogue_balloon(dialogue, "trash", [chem_inventory])


func _on_trash_body_entered(_body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_trash_body_exited(_body: Node2D) -> void:
	interactable = false
	$Glint.hide()
