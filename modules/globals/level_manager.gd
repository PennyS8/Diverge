extends Node2D

@export var current_level : Node2D
@export var fade_time := 0.5
@onready var fade_screen = %TransitionOverlay

@onready var entrances : Dictionary

var player
var transitioning := false

func change_level(path : String, entrance_name : String = ""):
	if transitioning:
		return
	transitioning = true
	
	player = get_tree().get_first_node_in_group("player")
	
	# save level state
	var tween = get_tree().create_tween()
	tween.set_parallel(false)
	tween.tween_property(fade_screen, "color:a", 1, fade_time)
	tween.tween_callback(_swap_level.bind(path, entrance_name))
	tween.tween_property(fade_screen, "color:a", 0, fade_time)
	tween.finished.connect(_transition_complete)

func _swap_level(path : String, entrance_name : String = ""):
	player.lock_camera = true

	var packed = load(path)
	var level = packed.instantiate()
	add_child(level)
	
	remove_child(current_level)
	current_level.queue_free()
	current_level = level
	
	_get_entrances()

	if entrances.has(entrance_name):
		player.global_position = entrances[entrance_name]
	else:
		player.global_position = Vector2.ZERO


func _get_entrances():
	entrances.clear()
	for entrance in get_tree().get_nodes_in_group("level_entrance"):
		entrances[entrance.name] = entrance.position

func _transition_complete():
	player.lock_camera = false
	transitioning = false
