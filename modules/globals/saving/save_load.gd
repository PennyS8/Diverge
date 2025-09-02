class_name SaveLoad
extends Node

signal main_ready

var player
var main : Node2D

#region Ready Functions
func _ready() -> void:
	main_ready.connect(_main_ready)

func _main_ready():
	player = get_tree().get_first_node_in_group("player")
	main = get_tree().current_scene
#endregion

#region Full game saving, loading, and deleting
# Saves all data from the game (rooms, player data, etc)
func save_game():
	# Saves the current room info into temp before making all saves permenant
	room_save(LevelManager.current_level.name)
	
	print("Saved game")
	
	## TODO: Make the savegame file include the room that the player is currently
	## in along with all of the other information.
	var saved_game:SavedGame = SavedGame.new()
	
	# Saves player info for current room
	saved_game.player_health = player.health_component.health
	saved_game.player_position = player.global_position
	
	# Saves current room info
	saved_game.current_level_name = LevelManager.current_level.name
	saved_game.level_path = LevelManager.current_level.scene_file_path
	
	# Saves current respawn info
	saved_game.respawn_last_level_path = RespawnManager.last_level_path
	saved_game.respawn_last_level_name = RespawnManager.last_level_name
	saved_game.respawn_last_entrance = RespawnManager.last_entrance
	
	ResourceSaver.save(saved_game, "user://saves/savegame.tres")
	
	var temp_dir_path = "user://temp"
	var dir_path = "user://saves"
	
	# Attempts to open permanent save path. If it doesn't exist, create it
	var dir
	if dir_exists(dir_path):
		dir = DirAccess.open(dir_path)
		
		# Makes sure save directory properly opened. If not we return
		if !dir:
			print("Save directory could not be opened")
			return
	else:
		DirAccess.make_dir_absolute(dir_path)
	
	# Checks if there are current room saves. If so we load them into the permanent dir
	if dir_exists(temp_dir_path):
		var temp_dir = DirAccess.open(temp_dir_path)
		
		if temp_dir:
			temp_dir.list_dir_begin()
			var file_name = temp_dir.get_next()
				
			while file_name != "":
				var temp_file_path = temp_dir_path + "/" + file_name
				var perm_file_path = dir_path + "/" + file_name
				
				if temp_dir.file_exists(temp_file_path):
					DirAccess.copy_absolute(temp_file_path, perm_file_path)
				else:
					print("File " + file_name + " does not exist")
					
				file_name = temp_dir.get_next()
			
			temp_dir.list_dir_end()
		else:
			print("Temp folder could not be opened for game save")
	else:
		print("Temp folder does not exist")

## TODO: Have this load the specific save file that is saved in the save_game() function. 
## This will be an after graduation thing when we want to implement save & load buttons.
# Loads all data from the game (rooms, player data, etc)
#func load_game(room_id):
	#print("Load game")
	#
	#var save_file = "user://savegame.tres"
	#
	## Makes sure to not load if save file doesn't exist
	#if !(save_exists(save_file)):
		#print("No existing save file.")
		#return
#
	#var saved_game:SavedGame = load(save_file)
	#
	#player.health_component.health = saved_game.player_health
	#player.global_position = saved_game.player_position
	#
	#get_tree().call_group("saved_data", "on_before_load_game")
	#
	#for item in saved_game.saved_data:
		#var scene = load(item.scene_path) as PackedScene
		#var restored_node = scene.instantiate()
		#var node = get_node(item.parent_node_path)
		#
		## Gets node name before resinstantiation. This is to prevent us from having
		## "CharacterBody@12" or some randomized name similar to that in Remote
		#var item_name = restored_node.name
		#
		## If the node path does not exist, add the item to main
		## NOTE: This should never occur but is more so a sanity check to be safe
		#if node != null:
			#node.add_child(restored_node)
		#else:
			#main.add_child(restored_node)
		#
		#if restored_node.has_method("on_load_game"):
			#restored_node.on_load_game(item)
		#
		## Checks if the restored node name has been set to randomized unique name. If
		## so, it renames it to what the item is and Godot adds a unique identifier
		#if restored_node.name != item_name:
			#restored_node.name = item_name

func load_game():
	print("Load Game")
	
	var save_file = "user://saves/savegame.tres"
	
	if !(save_exists(save_file)):
		print("No existing save file.")
		return
	
	var saved_game:SavedGame = load(save_file)
	
	# Sets the scene path to be loaded
	LevelManager.custom_scene_path = saved_game.level_path
	
	# Resets the last respawn information incase player dies in loaded room
	RespawnManager.last_level_path = saved_game.respawn_last_level_path
	RespawnManager.last_level_name = saved_game.respawn_last_level_name
	RespawnManager.last_entrance = saved_game.respawn_last_entrance
	
	var temp_dir_path = "user://temp"
	var dir_path = "user://saves"
	
	# Attempts to open temp save path. If it doesn't exist, create it
	var temp_dir
	if dir_exists(temp_dir_path):
		temp_dir = DirAccess.open(temp_dir_path)
		
		# Makes sure save directory properly opened. If not we return
		if !temp_dir:
			print("Save directory could not be opened")
			return
	else:
		DirAccess.make_dir_absolute(temp_dir_path)
	
	# Checks if there are current room saves. If so we load them into the permanent dir
	if dir_exists(dir_path):
		var dir = DirAccess.open(dir_path)
		
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			
			# Copies files over from the save folder to the temp folder
			while file_name != "":
				#If we see the savegame file, we want to move past it
				if file_name == "savegame.tres":
					file_name = dir.get_next()
					continue
				
				var temp_file_path = temp_dir_path + "/" + file_name
				var perm_file_path = dir_path + "/" + file_name
				
				if dir.file_exists(perm_file_path):
					DirAccess.copy_absolute(perm_file_path, temp_file_path)
				else:
					print("File " + file_name + " does not exist")
					
				file_name = dir.get_next()
			
			dir.list_dir_end()
		else:
			print("Temp folder could not be opened for game save")
	else:
		print("Temp folder does not exist")
	
	
	## TODO: Most likely need to delete this in future.
	#await room_load(saved_game.current_level_name)
	
	#player = get_tree().get_first_node_in_group("player")
	
	#player.health_component.health = saved_game.player_health
	#player.global_position = saved_game.player_position

# Deletes a full game save
func delete_perm_saves():
	var save_path = "user://saves"
	
	if dir_exists(save_path):
		var dir = DirAccess.open(save_path)
		
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			
			while file_name != "":
				var file_path = save_path + "/" + file_name
				
				if dir.file_exists(file_path):
					dir.remove(file_path)
				else:
					print("File " + file_name + " does not exist")
				
				file_name = dir.get_next()
			
			dir.list_dir_end()
		else:
			print("Saves directory could not be opened")
		
		# Removes the saves directory once we have deleted all files within it
		DirAccess.remove_absolute(save_path)
	else:
		print("Saves directory does not exist")
#endregion

#region Room saving, loading, and deleting
# Saves data of a given room into a temporary directory 
func room_save(room_id):
	# TODO: Once full game save is implemented for save buttons, change this to 
	# a temp folder
	var save_path = "user://temp"
	
	if DirAccess.open(save_path) == null:
		DirAccess.make_dir_absolute(save_path)
	
	print("Saved Level: " + room_id)
	
	var saved_room:SavedGame = SavedGame.new()
	
	var saved_data:Array[SavedData] = []
	# Calls the 'on_save_game' function on all entities with the 'saved_data' group.
	# This being enemies, items, etc.
	get_tree().call_group("saved_data", "on_save_game", saved_data)
	saved_room.saved_data = saved_data
	
	var save_room_path = save_path + "/saveroom_{id}.tres"
	var format_path = save_room_path.format({"id": room_id})
	ResourceSaver.save(saved_room, format_path)

# Loads data of a given room from the temporary directory if it exists
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

# Deletes all room save files before deleting the temp directory as a whole
func delete_temp_saves():
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
#endregion

#region Player save and load
# Saves the player's health and position
func save_player():
	var save_path = "user://saves"
	
	if DirAccess.open(save_path) == null:
		DirAccess.make_dir_absolute(save_path)
	
	print("Saved Player")
	
	var saved_player:SavedGame = SavedGame.new()
	
	saved_player.player_health = player.health_component.health
	saved_player.player_max_health = player.health_component.max_health
	saved_player.player_position = player.global_position
	# Gets name of level player is being saved in
	saved_player.level_path = LevelManager.current_level.scene_file_path
	
	
	var save_player_path = save_path + "/player_save.tres"
	ResourceSaver.save(saved_player, save_player_path)

# Loads the player's health and position upon loading up the game
func load_player(loaded_level):
	var player_save = "user://saves/player_save.tres"
	
	print("Load player save information")
	
	if !(save_exists(player_save)):
		print("No existing player save")
		return
	
	var saved_player:SavedGame = load(player_save)
	
	# Sets the player's hud to visibly show health
	var hud = get_tree().get_first_node_in_group("gui")
	#TODO: Get player health reseting fully working in future
	#var health_difference = saved_player.player_max_health - saved_player.player_health
	#if player.health_component.health <= 0:
		#hud.heart_heal(saved_player.player_health)
	#else:
		#hud.heart_damage(health_difference)
	
	hud.heart_heal(saved_player.player_max_health)
	
	# Loads player's health and position
	player.health_component.health = saved_player.player_health
	player.health_component.max_health = saved_player.player_max_health
	# Only loads players global_position if they are loaded into the same room
	# they were saved from
	if loaded_level == saved_player.level_path:
		player.global_position = saved_player.player_position
		
#endregion

# Helper functions checking if save files / folders exist.
func save_exists(save_file : String):
	return FileAccess.file_exists(save_file)

func dir_exists(save_dir : String):
	return DirAccess.dir_exists_absolute(save_dir)
