extends TetherableBody

@export var key_id := 0
@export var state := true

@export var weight : float = 0.0
@export var yarn_height : float = 0.0

var picked_up := false

func on_save_game(saved_data:Array[SavedData]):
	if picked_up == true:
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
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

func _on_item_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().got_key()
		KeyChain.num_smallkeys += 1
		picked_up = true
		queue_free()
