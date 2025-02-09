extends Area2D

@export var key_id := 0
@export var state := true

var picked_up := false

func on_save_game(saved_data:Array[SavedData]):
	if picked_up == true:
		return
		
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.puzzle_key_id = key_id
	
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	key_id = saved_data.puzzle_key_id

func _on_body_entered(body):
	if body.is_in_group("player"):
		KeyChain.num_smallkeys += 1
		picked_up = true
		queue_free()
