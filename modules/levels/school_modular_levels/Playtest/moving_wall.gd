extends Node2D

var first_played = false
var second_played = false

func _ready():
	KeyChain.key.connect(move_wall)

func move_wall(key, status):
	match key:
		5:
			if status and !first_played:
				$AnimationPlayer.play("first_move")
				first_played = true
		8:
			if status and !second_played:
				$AnimationPlayer.play("second_move")
				second_played = true
				$TileMapLayer.position = Vector2(288.0, 0.0)

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.puzzle_completed = second_played
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	
	if saved_data.puzzle_completed:
		$TileMapLayer.position = Vector2(288.0, 0)
		$Movingwallstg2.position = Vector2(288.0, 0)
		first_played = true
		second_played = true

func _on_camera_boundry_2_body_entered(_body):
	first_played = true
	second_played = true


func _on_camera_boundry_body_entered(_body):
	pass # Replace with function body.


func _on_hallway_west_body_entered(body):
	first_played = true
	second_played = true
