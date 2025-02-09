extends Area2D

@export var sprite1 : Texture2D
@export var sprite2 : Texture2D

@export var key_in := false

@export var key_id := 0

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.puzzle_completed = key_in
	my_data.puzzle_key_id = key_id
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	key_id = saved_data.puzzle_key_id
	
	# Similar code to the on_body_entered, but doesn't take a key from the player.
	if saved_data.puzzle_completed == true:
		key_in = true
		$Sprite2D.texture = sprite2
		KeyChain.key.emit(key_id, true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !key_in:
		if KeyChain.num_smallkeys > 0:
			key_in = true
			KeyChain.num_smallkeys -= 1
			$Sprite2D.texture = sprite2
			KeyChain.key.emit(key_id, true)
