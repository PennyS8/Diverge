extends Area2D

var interactable : bool = false

@export var start_word : String
var character: Node2D

func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		character.dir = Vector2.ZERO
		var dialogue = load("res://modules/dialogue/interactables.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, start_word)
		get_viewport().set_input_as_handled()

func _on_body_entered(body: Node2D) -> void:
	interactable = true
	character = body


func _on_body_exited(body: Node2D) -> void:
	interactable = false
