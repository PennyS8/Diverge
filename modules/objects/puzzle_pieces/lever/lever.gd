extends TetherableBody

@export var key_id := 0
@export var toggled := false
@onready var tetherable_area = $TetherableArea2D

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.puzzle_completed = toggled
	my_data.puzzle_key_id = key_id
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	key_id = saved_data.puzzle_key_id
	
	if saved_data.puzzle_completed == true:
		flip()

func hit(_area : HitBoxComponent2D):
	if _area.is_in_group("hook"):
		flip()

# Override
func fling(): #func fling(fling_point : Vector2):
	remove_tethered_status()
	var fling_point = Vector2(-1, 0) # TODO: Define fling_point by finding the other tethered_body
	
	var fling_dir = global_position.direction_to(fling_point).normalized()
	#var component_x = abs(fling_dir.x)
	#var component_y = abs(fling_dir.y)
	# if the lever is being pulled left or right enough to be flipped
	if abs(fling_dir.x) > abs(fling_dir.y):
		# if lever is right and pulled left, or if lever is left and pulled right, flip the lever
		if toggled and fling_dir.x > 0 or !toggled and fling_dir.x < 0:
			flip() # if lever is right and pulled left, flip

# Override
func pull():
	pass

func flip():
	if !toggled:
		toggled = true
		$Sprite2D.frame = 1
		$Sprite2D.offset.x = -8
		KeyChain.key.emit(key_id, true)
	else:
		toggled = false
		$Sprite2D.frame = 0
		$Sprite2D.offset.x = 8
		KeyChain.key.emit(key_id, false)

func _on_tetherable_area_2d_mouse_entered() -> void:
	select()

func _on_tetherable_area_2d_mouse_exited() -> void:
	deselect()
