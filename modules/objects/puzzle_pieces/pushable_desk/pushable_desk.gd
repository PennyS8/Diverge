extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var frames = sprite.texture.get_width() / sprite.region_rect.size.x

var default_position
var pushing := false

# TODO: Figure out how to pass the specific sprite texture in the future
# to allow for multiple desk sprites.
func _ready() -> void:
	var random = randi_range(0, frames - 1)
	sprite.region_rect.position.x = random * sprite.region_rect.size.x
	
	default_position = global_position

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	
	my_data.position = default_position
	my_data.scene_path = scene_file_path
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

func push(area: HitBoxComponent2D):
	var direction = area.get_parent().swing_dir
	direction = direction * $BodyCollider.shape.size.x
	if !move_and_collide(direction, true):
		if !pushing:
			pushing = true
			var twe = create_tween()
			twe.tween_property(self, "global_position", global_position + direction, 0.2)
			twe.finished.connect(set.bind("pushing", false))
