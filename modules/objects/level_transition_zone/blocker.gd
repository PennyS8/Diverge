extends StaticBody2D

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.blocker_scale = scale
	my_data.blocker_collision_scale = $CollisionShape2D.scale
	my_data.vertical_blocker_visible = $FirewallVertical.visible
	my_data.horizontal_blocker_visible = $FirewallHorizontal.visible

	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	scale = saved_data.blocker_scale
	$CollisionShape2D.scale = saved_data.blocker_collision_scale
	$FirewallVertical.visible = saved_data.vertical_blocker_visible
	$FirewallHorizontal.visible = saved_data.horizontal_blocker_visible
	
	## TODO: Try to find a better way to set the blocker since it is bad practice
	## to access the parent from the child. Considering we are only using blockers
	## for transition zones currently, we shouldn't encounter problems but that
	## may change if we use blockers in other places. 
	# Reassigns the transition zones blocker variable so that it can be removed later.
	get_parent().blocker = self
