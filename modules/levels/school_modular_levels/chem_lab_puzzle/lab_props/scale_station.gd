extends StaticBody2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")

func _unhandled_input(event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		var dialogue = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/interactions/chem_lab_stations.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "scale")

func _on_scale_body_entered(body: Node2D) -> void:
	interactable = true

func _on_scale_body_exited(body: Node2D) -> void:
	interactable = false
