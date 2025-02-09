extends StaticBody2D

@export var key_id := 0
@export var toggled := false
@onready var status_holder = get_node("StatusHolder")

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.puzzle_completed = toggled
	my_data.puzzle_key_id = key_id
	
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

func fling(fling_point : Vector2):
	var fling_dir = global_position.direction_to(fling_point).normalized()
	var component_x = abs(fling_dir.x)
	var component_y = abs(fling_dir.y)
	# if the lever is being pulled left or right enough to be flipped
	if abs(fling_dir.x) > abs(fling_dir.y):
		# if lever is right and pulled left, or if lever is left and pulled right, flip the lever
		if toggled and fling_dir.x > 0 or !toggled and fling_dir.x < 0:
			flip() # if lever is right and pulled left, flip

func pull():
	pass
	#var player =  get_tree().get_nodes_in_group("player")[0]
	#var player_pos = player.global_position + Vector2(0, -8)
	#var pull_dir = global_position.direction_to(player_pos).normalized()
	#var new_pos = global_position + pull_dir*THREAD_LENGTH + Vector2(0, 8)
	#player.global_position = new_pos
	#
	## this logic is so that we find which of the four cardinals our mouse is \
	## closest to. whichever absolute value is larger determines which \
	## component (x or y) we want to take as the main value.
	#var component_x = abs(pull_dir.x)
	#var component_y = abs(pull_dir.y)
	## if the lever is being pulled left or right enough to be flipped
	#if abs(pull_dir.x) > abs(pull_dir.y):
		## if lever is right and pulled left, or if lever is left and pulled right, flip the lever
		#if toggled and pull_dir.x > 0 or !toggled and pull_dir.x < 0:
			#flip()
			#if get_node("StatusHolder").get_node("Tethered"):
				#get_node("StatusHolder").remove_status("tethered")

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
