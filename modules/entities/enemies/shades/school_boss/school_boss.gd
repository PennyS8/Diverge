extends TetherableBody

var follow_object
var default_position
var crowd_control := false

@onready var fsm = $BossFSM

func _ready() -> void:
	default_position = global_position

func tethered_stun():
	crowd_control = true
	$BossFSM.change_state("Stunned")
	
	# turns crowd control back off for future
	crowd_control = false

#region Save and Load
func on_save_game(saved_data:Array[SavedData]):
	# Boss is dead if true
	if %Health.health <= 0:
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	default_position = saved_data.position
#endregion

#region Health Components
func _on_hurt_box_component_hit(_area : HitBoxComponent2D) -> void:
	pass

func _on_health_component_died() -> void:
	fsm.change_state("Dead")
#endregion

#region Tetherable Area
func _on_tetherable_area_2d_mouse_entered() -> void:
	select()

func _on_tetherable_area_2d_mouse_exited() -> void:
	deselect()
#endregion
