extends Area2D

const Balloon = preload("res://modules/dialogue/balloon/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "desk"

func action() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
