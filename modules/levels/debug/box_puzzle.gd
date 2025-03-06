extends Node2D

# Each room is the key, to a list of transition_zones (for dynamic transition_zones)
var room_transitions = {}

func update_room_transitions_dict():
	# Define the room_transitions dictionary of all rooms and thier transitions
	for room in get_tree().get_nodes_in_group("room_with_dynamic_transitions"):
		var room_exits : Array[Node] = room.get_node("Exits").get_children()
		room_transitions[room.name] = room_exits

func on_save_game(saved_data: Array[SavedData]):
	update_room_transitions_dict()
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.room_transitions = room_transitions
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data: SavedData):
	global_position = saved_data.position
	room_transitions = saved_data.room_transitions
	
	for room in get_tree().get_nodes_in_group("room_with_dynamic_transitions"):
		var exit_parent_node = room.get_node("Exits")
		for old_exit in exit_parent_node.get_children():
			exit_parent_node.remove_child(old_exit)
			old_exit.queue_free()
		
		for new_exit in room_transitions[room.name]:
			exit_parent_node.add_child(new_exit)

func _on_room_a_north_body_entered(body: Node2D) -> void:
	var letter = body.name.substr(len(body.name)-1, -1) # Get last letter of body.name
	var entrance = letter + "South"	
	var exit = get_node("RoomA/Exits/ANorth")
	
	print("exit: " + exit.name + "\nentrance: " + entrance)
	exit.entrance_name = entrance

func _on_room_a_east_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func _on_room_a_south_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func _on_room_a_west_body_entered(body: Node2D) -> void:
	pass # Replace with function body.



func _on_room_a_north_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_room_a_east_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_room_a_south_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_room_a_west_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
