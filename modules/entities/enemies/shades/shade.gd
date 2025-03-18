extends TetherableBody

@export var hitpoints : int
@export var movement_speed : float

var follow_target
var knockback : Vector2 = Vector2.ZERO
var crowd_control := false

signal pick_up(body)

var default_position

func on_save_game(saved_data:Array[SavedData]):
	if $HealthComponent.health <= 0: 
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

func _ready() -> void:
	default_position = global_position

func fling(): 
	$ShadeFSM.change_state("Stunned")
	super.fling()

func pull():
	$ShadeFSM.change_state("Stunned")
	super.pull()

func _physics_process(_delta: float) -> void:
	super(_delta)
	$AgroRegion.look_at(to_global(velocity))
	if sliding_to_target:
		$AgroRegion.monitoring = false
	else:
		$AgroRegion.monitoring = true
	
	if get_node_or_null("SoftCollision"):
		if $SoftCollision.is_colliding():
			velocity += $SoftCollision.get_push_vector() * _delta * 200
	

func _on_health_component_died() -> void:
	$ShadeFSM.change_state("Dead")

func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	if $HealthComponent.health > 0:
		knockback = _area.global_position.direction_to(global_position) * _area.knockback_coef
		if _area.get_parent().is_in_group("player"):
			$ShadeFSM.change_state("Stunned", _area.get_parent())
		else:
			$ShadeFSM.change_state("Stunned")

		$Display/HitFX.restart()
		$HitflashPlayer.play("Hitflash")
	else:
		$Display/HitFX.restart()
		$HitflashPlayer.play("Hitflash")
		$ShadeFSM.change_state("Dead")

#func _on_agro_region_body_exited(_body):
	#follow_target = null
	#$ShadeFSM.change_state("Roaming")

func _on_tetherable_area_2d_mouse_entered() -> void:
	select()

func _on_tetherable_area_2d_mouse_exited() -> void:
	deselect()

# Removes the knockback from the enemy for tethering but still stuns enemy
func tethered_stun():
	crowd_control = true
	$ShadeFSM.change_state("Stunned")
	
	# turns crowd control back off for future
	crowd_control = false
