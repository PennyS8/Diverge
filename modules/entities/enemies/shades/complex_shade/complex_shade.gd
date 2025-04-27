extends TetherableBody

## this value acts as the "current movement speed" - to change the speed of individual[br]
## states, change the state_movespeed variable on the cooresponding state
var movement_speed : float = 30.0
var follow_object

var knockback : Vector2 = Vector2.ZERO
var crowd_control := false

var default_position

@onready var damaged_particles = $DisplayComponents/HitFX
@onready var fsm = $ShadeFSM

@onready var health_component = %Health
@onready var hurtbox = %HurtBox

## NATE - STEERING BEHAVIORS
var ai_steering := AISteering.new()
var strafe_factor := 0.25
##############

# For encounters to see when spawn animation is finished
signal spawned

func _ready() -> void:
	default_position = global_position

func _physics_process(_delta: float) -> void:
	# Vision Cone rotates to direction walked
	%AgroRegion.look_at(to_global(velocity))
	super(_delta)
	
# Removes the knockback from the enemy for tethering but still stuns enemy
func tethered_stun():
	crowd_control = true
	fsm.change_state("Stunned")
	
	# turns crowd control back off for future
	crowd_control = false
	
func fling(): 
	fsm.change_state("Stunned")
	super.fling()

func pull():
	fsm.change_state("Stunned")
	super.pull()

#region Savegame
func on_save_game(saved_data:Array[SavedData]):
	if %Health.health <= 0: 
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
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

#region Damage Handling
func _on_health_component_died() -> void:
	damaged_particles.restart()
	fsm.change_state("Dead")
	%AnimationPlayer.call_deferred("play", "die")


func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	# Apply knockback from the Hitbox's "knockback_coefficient"
	knockback = _area.global_position.direction_to(global_position) * _area.knockback_coef
	
	damaged_particles.set_deferred("rotation", get_angle_to(-knockback) + PI)
	
	# If, after damaging, we'll still be alive, stun us
	if (health_component.health - _area.damage) > 0:
		%AnimationPlayer.call_deferred("play", "damaged")
		fsm.call_deferred("change_state", "Stunned")

		damaged_particles.restart()
		
		# If the attacking _area is the players thread apply the tethered status effect
		if _area.is_in_group("thread"):
			add_tethered_status()
#endregion

#region TetherableArea Selection
func _on_tetherable_area_2d_mouse_entered() -> void:
	select()

func _on_tetherable_area_2d_mouse_exited() -> void:
	deselect()
#endregion

func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
	await tween.finished
