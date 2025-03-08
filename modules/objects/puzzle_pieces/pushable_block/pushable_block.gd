extends CharacterBody2D

var pushing := false
var puzzle_completed := false
var default_position

func _ready() -> void:
	default_position = global_position

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	
	# Checks if puzzle is completed, if not it gets the default position regardless
	# of where is gets moved. 
	if puzzle_completed == true:
		my_data.position = global_position
	else:
		my_data.position = default_position
	
	my_data.scene_path = scene_file_path
	my_data.puzzle_completed = puzzle_completed
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	# Assigns saved position to default in order to prevent box from saving (0,0) location.
	default_position = saved_data.position

func push(area : HitBoxComponent2D):
	var direction = area.get_parent().swing_dir
	direction = direction * 24 # TODO: STOP Overriding: $BodyCollider.shape.size.x
	if !move_and_collide(direction, true):
		if !pushing:
			pushing = true
			var twe = create_tween()
			twe.tween_property(self, "global_position", global_position + direction, 0.2)
			twe.finished.connect(set.bind("pushing", false))
