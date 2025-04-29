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
	if(player.dialogue_tracker["closet"] == false):
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "hiding_away", [self])
		player.dialogue_tracker["closet"] = true
	
		await DialogueManager.dialogue_ended
		#LevelManager.enter_tutorial("AttackTutorial")

func _on_body_exited(body: Node2D) -> void:
	self.queue_free()

#func spawn_shade():
	#var shade_packed : PackedScene = load("res://modules/entities/enemies/shades/complex_shade/complex_shade.tscn")
	#shade = shade_packed.instantiate()
	#shade.get_node("%ShadeFSM").disabled = true
	#
	#shade.global_position = shade_spawn_point.global_position
	
