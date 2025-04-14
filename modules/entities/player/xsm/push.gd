@tool
extends StateAnimation

# passed in walk transition so that we know if we stop pushing in this dir
# to leave the state
var push_dir

func _on_enter(_args) -> void:
	print("DEBUG: pushing!")
	# initialize push direction. if this doesn't match target.dir, transition out
	if _args:
		push_dir = _args
	else:
		push_dir = target.dir

func _on_update(_delta: float) -> void:
	var collision = target.get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			var tile_rid = collision.get_collider_rid()
			
			var collision_layer = PhysicsServer2D.body_get_collision_layer(tile_rid)
			if (collision_layer & 1) == 1:
				var hop_pos
				var is_pitfall
				if collider.tile_set.get_custom_data_layer_by_name("end_location") > -1:
					var ledge_data = _get_ledge_end_position(tile_rid, collider)
					hop_pos = ledge_data[0]
					is_pitfall = ledge_data[1]
				else:
					printerr("no end_location data layer on ledge tile")
					return
				
				# layer bitmask contains "ledge"
				var args = [push_dir, hop_pos, is_pitfall]
				change_state("Hop", args)

func _get_ledge_end_position(tile_rid : RID, collider : TileMapLayer):
	var coords = collider.get_coords_for_body_rid(tile_rid)
	var data = collider.get_cell_tile_data(coords)
	if data:
		var custom_data = data.get_custom_data("end_location")
		if custom_data:
			var end_pos = collider.map_to_local(coords) + custom_data
			var local_tile_pos = collider.local_to_map(end_pos)
			var is_pit = _is_pitfall(local_tile_pos, collider)
			return [custom_data, is_pit]
		else: return [Vector2.ZERO, false]
	else:
		return [Vector2.ZERO, false]

func _is_pitfall(end_coords : Vector2, collider : TileMapLayer) -> bool:
	var data = collider.get_cell_tile_data(end_coords)
	if data:
		var custom_data = data.get_custom_data("is_pitfall")
		if custom_data:
			return custom_data
		else: return false
	else:
		return false

func _after_update(_delta: float) -> void:
	# base state: if not moving, get out of push
	if target.dir != push_dir:
		change_state("Idle")

func _before_exit(_args) -> void:
	print("DEBUG: not pushing!")
