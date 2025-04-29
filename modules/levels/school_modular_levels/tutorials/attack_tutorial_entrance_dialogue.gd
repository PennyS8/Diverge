extends Area2D

var read : bool = false
@onready var shade = $"../ComplexShade"
@onready var player = get_tree().get_first_node_in_group("player")

func _on_body_entered(_body: Node2D) -> void:
	if read: # Don't allow this dialogue to be read more than once
		return
	
	read = true
	
	shade.get_node("ShadeFSM").disabled = true
	player.dir = Vector2.ZERO
	
	var dialogue = load("res://modules/levels/school_modular_levels/tutorials/tutorials.dialogue")
	await DialogueManager.show_dialogue_balloon(dialogue, "attack_tutorial")
