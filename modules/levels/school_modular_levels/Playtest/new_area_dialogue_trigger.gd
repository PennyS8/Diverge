extends Area2D

var player
var shade

@export var shade_spawn_point : Marker2D
@export var shade_parent : Node2D

func _ready() -> void:
	pass
	

func _on_body_entered(body: Node2D) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(1)
	await timer.timeout
	player = LevelManager.player
	if(player.dialogue_tracker["new_hallway"] == false):
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "new_hallway", [self])
		player.dialogue_tracker["new_hallway"] = true
