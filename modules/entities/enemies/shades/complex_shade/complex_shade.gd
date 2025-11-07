extends TetherableBody

## this value acts as the "current movement speed" - to change the speed of individual[br]
## states, change the state_movespeed variable on the cooresponding state
var movement_speed : float = 30.0
var follow_object

## The force applied by an attack or other "explosive" push
var knockback : Vector2 = Vector2.ZERO

## The force applied on the shade by its neighbor shades using soft_collision
var separation_push : Vector2 = Vector2.ZERO

## The direction*magnitude of our pathfinding code with LimboAI
var pathing_velocity : Vector2 = Vector2.ZERO

var crowd_control := false
var idle_dir := "left"
var default_position

@onready var damaged_particles = $DisplayComponents/HitFX
#@onready var fsm = $ShadeFSM

@onready var health_component = %Health
@onready var hurtbox = %HurtBox
@onready var tetherable_area = $TetherableArea2D

## This edits our max health variable
@export var max_health := 40

@onready var heart_node = preload("res://modules/objects/debug/heal_area/heal_area.tscn")

# Stuff imported / adjusted for LimboAI import
var _moved_this_frame := false
var _frames_since_facing_update := 0
@onready var root = %DisplayComponents
@onready var soft_collision = %SoftCollision

var is_hit_this_frame := false
var is_attacking := false
## NATE - STEERING BEHAVIORS
var ai_steering := AISteering.new()
var strafe_factor := 0.25
##############

# For encounters to see when spawn animation is finished
signal spawned

func _ready() -> void:
	default_position = global_position
	%Health.max_health = max_health
	
func _physics_process(_delta: float) -> void:
	# Applies neighbor separation as well as pathing velocity from decision tree
	separation_push = soft_collision.get_push_vector() * 15.0
	
	velocity = separation_push + pathing_velocity
	move_and_slide()
	
	# Vision Cone rotates to direction walked
	%AgroRegion.look_at(to_global(velocity))
	super(_delta)

	_post_physics_process.call_deferred()

func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
		pathing_velocity = Vector2.ZERO
	
	_moved_this_frame = false

# Removes the knockback from the enemy for tethering but still stuns enemy
func tethered_stun():
	crowd_control = true
	$AnimationPlayer.call_deferred("play", "RESET")
#	fsm.change_state("Stunned")
	
	# turns crowd control back off for future
	crowd_control = false
	
func fling():
	$AnimationPlayer.call_deferred("play", "RESET")
	#fsm.change_state("Stunned")
	super.fling()

func pull():
	$AnimationPlayer.call_deferred("play", "RESET")
	#fsm.change_state("Stunned")
	super.pull()

#region Savegame
func on_save_game(saved_data:Array[SavedData]):
	if %Health.health <= 0: 
		return
	
	if is_in_group("haha_not_actually_in_saved_data_jk"):
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	my_data.max_health = %Health.max_health

	# Find any active encounters and mark enemies that are apart of the encounter
	# in order to readd them to the encounter upon loading.
	var encounter_entrances = get_tree().get_nodes_in_group("encounter_entrance")
	for entrance in encounter_entrances: 
		# Checks to make sure that enemy hasn't been marked as true in a
		# different active encounter. This is a sanity check as realistically
		# we won't have 2 active encounters at the same time. 
		if entrance.is_currently_running && my_data.enemy_in_encounter != true:
			my_data.enemy_in_encounter = entrance.encounter_has_enemy(self)
	
	# If no active encounter is found, make sure it is set to false
	if my_data.enemy_in_encounter != true:
		my_data.enemy_in_encounter = false
	
	saved_data.append(my_data)

func on_before_load_game():
	if is_in_group("haha_not_actually_in_saved_data_jk"):
		return
	
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	if is_in_group("haha_not_actually_in_saved_data_jk"):
		return
	
	global_position = saved_data.position
	default_position = saved_data.position
	%Health.set_deferred("max_health", saved_data.max_health)
	
	# Wait before adding enemy in order to ensure encounter entrance exists
	if saved_data.enemy_in_encounter:
		await get_tree().create_timer(1.0, true).timeout
	
	# Reconnects enemies to encounter in order to remove encounter walls upon defeating enemies
	var encounter_entrances = get_tree().get_nodes_in_group("encounter_entrance")
	for entrance in encounter_entrances:
		if entrance.is_currently_running && saved_data.enemy_in_encounter:
			entrance.enemy_added(self)
#endregion

#region Damage Handling
func _on_health_component_died() -> void:
	$AnimationPlayer.call_deferred("play", "RESET")
	drop_ramen()
	drop_heart()
	damaged_particles.restart()
#	fsm.change_state("Dead")
	%AnimationPlayer.call_deferred("play", "die")

func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	# Apply knockback from the Hitbox's "knockback_coefficient"
	knockback = _area.global_position.direction_to(global_position) * _area.knockback_coef
	
	damaged_particles.set_deferred("rotation", get_angle_to(to_global(knockback)))
	
	# If, after damaging, we'll still be alive, stun us
	if (health_component.health - _area.damage) > 0:
		$AnimationPlayer.call_deferred("play", "RESET")
		
		#if idle_dir == "up":
			#%AnimationPlayer.call_deferred("play", "damaged_up")
		#elif idle_dir == "down":
			#%AnimationPlayer.call_deferred("play", "damaged_down")
		#else:
			#%AnimationPlayer.call_deferred("play", "damaged")

		#fsm.call_deferred("change_state", "Stunned")
		is_hit_this_frame = true
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

func drop_ramen():
	var ramen = get_node_or_null("RamenTray")
	if ramen:
		ramen.get_node("Sprite2D").call_deferred("reparent", ramen.get_node("CanvasGroup"))
		ramen.get_node("Item").call_deferred("set_collision_mask_value", 4, false)
		ramen.get_node("Item").set_deferred("monitoring", true)
		ramen.call_deferred("reparent", get_parent())
		#starts shining shader

func drop_heart():
	if follow_object:
		if follow_object.is_in_group("player"):
			var player_max_health = follow_object.health_component.max_health
			var player_health = follow_object.health_component.health
			
			if player_health < (player_max_health * 0.75):
				print("Dropping heart")
				var heart = heart_node.instantiate()
				var node = get_node(get_parent().get_path())
				node.call_deferred("add_child",heart)
				heart.set_deferred("global_position", self.global_position)

func release_player():
	EnemyManager.release_engagement(self)
	follow_object = null
	#fsm.change_state("Idle")

func move(p_velocity: Vector2) -> void:
	pathing_velocity = lerp(pathing_velocity, p_velocity, 0.2)
	_moved_this_frame = true

## Update agent's facing in the velocity direction.
func update_facing(target_dir) -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(target_dir.x)

## Face specified direction.
func face_dir(dir: float) -> void:
	if dir > 0.0 and root.scale.x < 0.0:
		root.scale.x = 1.0;
		_frames_since_facing_update = 0
	if dir < 0.0 and root.scale.x > 0.0:
		root.scale.x = -1.0;
		_frames_since_facing_update = 0

## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> float:
	return signf(root.scale.x)
	
## Is specified position inside the arena (not inside an obstacle)?
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = (1 << 2 - 1) | (1 << 5 - 1) # Wall is layer 2, obstacle is layer 5
	var collision := space_state.intersect_point(params)
	return collision.is_empty()
