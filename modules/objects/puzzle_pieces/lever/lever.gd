extends StaticBody2D

@export var key_id := 0
@export var toggled := false

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
		flip(1)

# structural unused param
func flip(_area):
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
