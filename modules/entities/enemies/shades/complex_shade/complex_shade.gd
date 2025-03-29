extends TetherableBody

## this value acts as the "current movement speed" - to change the speed of individual[br]
## states, change the state_movespeed variable on the cooresponding state
var movement_speed : float = 30.0

var follow_object
var knockback : Vector2 = Vector2.ZERO
var crowd_control := false

var default_position

@onready var nav_agent = %NavAgent


## NATE - STEERING BEHAVIORS
var ai_steering := AISteering.new()
var strafe_factor := 0.25
##############

func on_save_game(saved_data:Array[SavedData]):
	if %Health.health <= 0: 
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	default_position = saved_data.position

func _ready() -> void:
	default_position = global_position

func _physics_process(_delta: float) -> void:
	%AgroRegion.look_at(to_global(velocity))

func _on_health_component_died() -> void:
	$ShadeFSM.change_state("Dead")

func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	if %Health.health > 0:
		knockback = _area.global_position.direction_to(global_position) * _area.knockback_coef
		$ShadeFSM.change_state("Stunned")
		$DisplayComponents/CPUParticles2D.restart()
		
		# If the attacking _area is the players thread apply the tethered status effect
		if _area.is_in_group("thread"):
			add_tethered_status()
	else:
		$DisplayComponents/CPUParticles2D.restart()
		$ShadeFSM.change_state("Dead")

#func _on_agro_region_body_exited(_body):
	#follow_object = null
	#$ShadeFSM.change_state("Roaming")

func _on_tetherable_area_2d_mouse_entered() -> void:
	select()

func _on_tetherable_area_2d_mouse_exited() -> void:
	deselect()

# called by movement substates to set the end pos
func set_movement_goal(target_pos: Vector2):
	nav_agent.target_position = target_pos
