@tool
extends StateAnimation

# is passed in in walk transition so that we know if we stop pushing in this dir
# to leave the state
var push_dir

# NOTE: TODO: delete this comment block
# player.dir
# player.is_on_wall
# player.move_and_collide

# order of operations:
# if we're walking towards a wall

# This additional callback allows you to act at the end
# of an animation
func _on_anim_finished() -> void:
	pass


# This additionnal callback allows you to act at the end
# of an animation loop (after the nb of times it should play)
func _on_loop_finished() -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	print("DEBUG: pushing!")
	# initialize push direction. if this doesn't match target.dir, transition out
	if _args:
		push_dir = _args
	else:
		push_dir = target.dir


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	var collision = target.get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			var tile_rid = collision.get_collider_rid()
			
			var collision_layer = PhysicsServer2D.body_get_collision_layer(tile_rid)
			if (collision_layer & 1) == 1:
				var hop_pos
				if collider.tile_set.get_custom_data_layer_by_name("end_location") > -1:
					hop_pos = _get_ledge_end_position(tile_rid, collider)
				else:
					printerr("no end_location data layer on ledge tile")
					return
				
				# layer bitmask contains "ledge"
				var args = [push_dir, hop_pos]
				change_state("Hop", args)
			

func _get_ledge_end_position(tile_rid : RID, collider : TileMapLayer) -> Vector2:
	var coords = collider.get_coords_for_body_rid(tile_rid)
	var data = collider.get_cell_tile_data(coords)
	if data:
		var custom_data = data.get_custom_data("end_location")
		if custom_data:
			return custom_data
		else: return Vector2.ZERO
	else:
		return Vector2.ZERO

# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	# base state: if not moving, get out of push
	if target.dir != push_dir:
		change_state("Idle")


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	print("DEBUG: not pushing!")



# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
