class_name SaveLoad
extends Node

signal main_ready

var player
var main : Node2D

func _ready() -> void:
	main_ready.connect(_main_ready)

func _main_ready():
	player = get_tree().get_first_node_in_group("player")
	main = get_tree().current_scene

func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.player_health = player.health_component.health
	saved_game.player_position = player.global_position
	
	var saved_data:Array[SavedData] = []
	# Calls the 'on_save_game' function on all entities with the 'saved_data' group.
	# This being enemies, items, etc.
	get_tree().call_group("saved_data", "on_save_game", saved_data)
	saved_game.saved_data = saved_data
	
	ResourceSaver.save(saved_game, "user://savegame.tres")

func load_game():
	# Makes sure to not load if save file doesn't exist
	if !(save_exists("user://savegame.tres")):
		print("No existing save file.")
		return

	var saved_game:SavedGame = load("user://savegame.tres")
	
	player.health_component.health = saved_game.player_health
	player.global_position = saved_game.player_position
	
	get_tree().call_group("saved_data", "on_before_load_game")
	
	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		var node = get_node(item.parent_node_path)
		
		# If the node path does not exist, add the item to main
		# NOTE: This shouldn't ever occur but is moreso a sanity check to be safe
		if node != null:
			node.add_child(restored_node)
		else:
			main.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)

func delete_game_save():
	var format_path = "user://savegame.tres"
	
	if save_exists(format_path):
		DirAccess.remove_absolute(format_path)
	else:
		print("File doesn't exist")
		return

func room_save(room_id):
	if DirAccess.open("user://temp") == null:
		DirAccess.make_dir_absolute("user://temp")
	
	print("Saved Level: " + room_id)
	
	var saved_room:SavedGame = SavedGame.new()
	
	var saved_data:Array[SavedData] = []
	# Calls the 'on_save_game' function on all entities with the 'saved_data' group.
	# This being enemies, items, etc.
	get_tree().call_group("saved_data", "on_save_game", saved_data)
	saved_room.saved_data = saved_data
	
	var save_room_path = "user://temp/saveroom_{id}.tres"
	var format_path = save_room_path.format({"id": room_id})
	ResourceSaver.save(saved_room, format_path)

func room_load(room_id):
	var save_room_path = "user://temp/saveroom_{id}.tres"
	var format_path = save_room_path.format({"id": room_id})
	
	print("Loaded Level: " + room_id)
	
	# Makes sure to not load if save file doesn't exist
	if !(save_exists(format_path)):
		print("No existing save file.")
		return

	var saved_room:SavedGame = load(format_path)
	
	get_tree().call_group("saved_data", "on_before_load_game")
	
	for item in saved_room.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		var node = get_node(item.parent_node_path)
		
		# Gets node name before resinstantiation. This is to prevent us from having
		# "CharacterBody@12" or some randomized name similar to that in Remote
		var item_name = restored_node.name

		
		# If the node path does not exist, add the item to main
		# NOTE: This shouldn't ever occur but is moreso a sanity check to be safe
		if node != null:
			node.add_child(restored_node)
		else:
			main.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
		
		# Checks if the restored node name has been set to randomized unique name. If
		# so, it renames it to what the item is and Godot adds a unique identifier
		if restored_node.name != item_name:
			restored_node.name = item_name

func delete_room_saves():
	var room_save_path = "user://temp"
	
	if dir_exists(room_save_path):
		# Deletes files inside of folder to allow for folder to be deleted
		var dir = DirAccess.open(room_save_path)
		
		# Makes sure that the directory opens properly
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			
			while file_name != "":
				var file_path = room_save_path + "/" + file_name
				
				if dir.file_exists(file_path):
					dir.remove(file_path)
				else:
					print("File " + file_name + " does not exist")
				
				file_name = dir.get_next()
			
			dir.list_dir_end()
		else:
			print("Temp folder could not be opened")
		
		# Finally deletes folder once it is empty
		DirAccess.remove_absolute(room_save_path)
	else:
		print("Temp folder does not exist")

# Helper functions checking if save files / folders exist.
func save_exists(save_file : String):
	return FileAccess.file_exists(save_file)

func dir_exists(save_dir : String):
	return DirAccess.dir_exists_absolute(save_dir)
