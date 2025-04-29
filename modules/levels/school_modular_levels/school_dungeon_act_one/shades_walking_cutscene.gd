extends Area2D

var player

@export var juniper_spikes : Array[Marker2D]
var shades : Array[Node2D]

@export var shade_end_location : Node2D
signal shades_gone

func _on_body_entered(body: Node2D) -> void:
	$"../EncounterEntrance".begin_encounter.connect(start_cutscene, CONNECT_ONE_SHOT)

func start_cutscene():
	player = LevelManager.player
	
	shades.clear()
	for node in get_parent().get_children():
		if node.is_in_group("enemy"):
			shades.append(node)
	
	player.dir = Vector2.ZERO
	
	DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "foyer_encounter", [self])
	

func move_shades(point, speed : float = 30.0) -> void:
	for shade in shades:
		var poin = Vector2(shade_end_location.global_position.x, shade.global_position.y)
		var dist = shade.global_position.distance_to(poin)
		
		var tween = create_tween()
		tween.tween_property(shade, "global_position", poin, dist / speed)
		tween.tween_callback(_movement_done.bind(shade))
	await shades_gone
	
func _movement_done(shade):
	shade.get_node("%Health").damage(100)
	shades_gone.emit()
