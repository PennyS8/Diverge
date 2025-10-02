extends Area2D

#region Savegame
func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
#endregion

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player = get_tree().get_first_node_in_group("player")
		player.health_component.heal(2)
		
		# Once player has been healed, we just remove the area
		queue_free()
