extends Node2D

signal main_ready

var current_level : Node2D
var custom_scene_path : String

@export var fade_time := 0.5

@onready var fade_screen = %TransitionOverlay

@onready var entrances : Dictionary

@export var default_level : PackedScene

var main : Node2D
var new_level_name : String

var player
var transitioning := false
var found_player := false

signal swap_done

var overlay : Control
func _ready():
	var scene = get_tree().current_scene
	if scene is Control or scene is CanvasLayer:
		return
	if scene.name != "Main":
		if get_tree().get_first_node_in_group("player"):
			found_player = true
		custom_scene_path = get_tree().current_scene.scene_file_path
		get_tree().call_deferred("change_scene_to_file","res://modules/globals/main.tscn")
	main_ready.connect(_main_ready)
	await main_ready

func _main_ready():
	player = get_tree().get_first_node_in_group("player")
	if found_player:
		# Removes the player in the Main.tcsn, leaving the Player in the scene being loaded
		player.queue_free()
	main = get_tree().current_scene
	if custom_scene_path:
		await _swap_level(custom_scene_path)
		player.exit_cutscene()
	else:
		await _swap_level(default_level.resource_path)
		player.exit_cutscene()


func change_level(path : String, entrance_name : String = "0"):
	if transitioning:
		return
	transitioning = true
	
	player = get_tree().get_first_node_in_group("player")

	# save level state
	SaveAndLoad.room_save(current_level.get_name())
	
	var tween = get_tree().create_tween()
	tween.set_parallel(false)
	tween.tween_property(fade_screen, "color:a", 1, fade_time)
	tween.tween_callback(_swap_level.bind(path, entrance_name))
	
	await swap_done
	await player._camera_limit_update()
	await player.exit_cutscene()
	
	var tween_two = get_tree().create_tween()
	
	tween_two.tween_property(fade_screen, "color:a", 0, fade_time)


	tween_two.finished.connect(_transition_complete)

func _swap_level(path : String, entrance_name : String = "0"):
	var packed = load(path)
	var level = packed.instantiate()
	new_level_name = level.get_name()
	main.add_child(level)
	
	if current_level:
		main.remove_child(current_level)
		current_level.call_deferred("queue_free")
	current_level = level
	
	_get_entrances()

	if entrances.has(entrance_name):
		player.global_position = entrances[entrance_name]
		#player.enter_cutscene()
	else:
		player.global_position = Vector2.ZERO
	
	# Resets the scenes name if it gets set to a randomized name by Godot
	if current_level.name != new_level_name:
		current_level.name = new_level_name
	
	# Loads level while the tween is still happening to prevent player from seeing loading.
	SaveAndLoad.room_load(new_level_name)
	swap_done.emit()

func _get_entrances():
	entrances.clear()
	for entrance in get_tree().get_nodes_in_group("level_entrance"):
		entrances[entrance.name] = entrance.global_position

func _transition_complete():
	#player.exit_cutscene()
	transitioning = false

func deep_breath_overlay():
	var tween = create_tween()
	var blink_time = 1
	
	tween.set_parallel(true) # Perform next steps at the same time
	
	# Take away player control, fade to black (placeholder for "blink")
	tween.tween_callback(player.enter_cutscene)
	tween.tween_property(fade_screen, "color:a", 1, blink_time)
	
	# Next, once eyes are closed, begin to open eyes and set screen saturation to grayscale
	tween.chain().tween_property(fade_screen, "color:a", 0, blink_time)
	tween.tween_callback(black_white)
	
	# Wait for tween to be done fading in
	await tween.finished
	
	# Begin timer for deadeye mode, wait for timer to be done
	await start_deadeye()
	
	# Return control back to player
	player.exit_cutscene()

func black_white():
	if !overlay:
		overlay = get_tree().get_first_node_in_group("deep_breath")
	overlay.show()

func start_deadeye():
	overlay.start_mode()
	await overlay.done
