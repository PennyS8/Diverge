extends TetherableBody

# Most logic is handled by the xsm below
# Player keeps it own velocity, as well as vars that can be used by many different states

var lock_camera := false
var in_cutscene := false
var cutscene_walk_to_position := Vector2.ZERO

var dir : Vector2 = Vector2.ZERO
var idle_dir : Vector2 = Vector2.ZERO

var dialogue_open : bool = false

var moon_walk : bool = false

# swing_dir is a variable updated by our hook swing that gets the 
# nearest cardinal direction to our mouse click (n, e, s, w)
# we keep it in here to use it to push blocks in that direction
var swing_dir : Vector2

# if player is currently inside a "ledge" area, the reference to that is stored here
var ledge_collision : Area2D

var hook_locked := true
@export_category("Check Unlock Item Patterns")
@export var hook_type : ItemType
@export var yarn_bag_type : ItemType
@export var cope_type : ItemType
@export var dash_type : ItemType

# this is to pass unhandled input to states
signal unhandled_input_received(event)

@onready var health_component = $HealthComponent
var curr_camera_boundry : Area2D
@onready var anim_player = $AnimationPlayer
@onready var camera : Camera2D = $Camera2D
@onready var fsm : State = $PlayerFSM
@onready var hurtbox = $HurtBoxComponent2D

var is_invulnerable: bool = false
var fade_tween : Tween
@onready var character_sprite = $Sprite2D

var cutscene_marker_packed = preload("res://modules/objects/debug/cutscene_walk_point.tscn")
 

#makes sure certain dialogue popups only appear once
var dialogue_tracker = {"closet": false, "library": false, "new_hallway": false, 
	"boss_battled" : false, "end_scene": false, "deep_breath_practice": false}

var lab_stations = {"materials": 0, "scale": 0, "mixer": 0, "burner": 0, "book": 0}

signal attack_swung

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(dialogue_done)
	
func dialogue_done(resource : Resource) -> void:
	dialogue_open = false

func _unhandled_input(event: InputEvent) -> void:
	unhandled_input_received.emit(event)
	if !in_cutscene:
		_camera_move()
		dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _process(_delta):	
	# Camera Boundries MUST NOT overlap eachother, and must have the collision\
	# layer 9 (i.e., "CameraBoundryCollider").
	
	# if we're in cutscene or scene transition
	update_cam_limits()

func update_cam_limits():
	var areas = $Area2D.get_overlapping_areas()
	if !areas: # Check if null (or empty)
		return
	
	var area = areas[0]
	if area != curr_camera_boundry: # Only set the camera limits once
		curr_camera_boundry = area
		
		var top_right : Vector2 = area.get_node("LimitTopRight").global_position
		var bottom_left : Vector2 = area.get_node("LimitBottomLeft").global_position
		camera.limit_top = top_right.y
		camera.limit_right = top_right.x
		camera.limit_bottom = bottom_left.y
		camera.limit_left = bottom_left.x

func give_hook():
	if GameManager.inventory_node:
		var inv : RestrictedInventory = GameManager.inventory_node.inventory
		InventoryHelper.add_itemtype_to_inventory(inv, hook_type, 1)
		
# Checks for all player ability unlocks. Unlocks FSM states if item found in inventory
func check_unlock_hook():
	if GameManager.inventory_node:
		var inv : RestrictedInventory = GameManager.inventory_node.inventory
		if InventoryHelper.is_itemtype_in_inventory(inv, hook_type):
			$PlayerFSM/Movement/AttackMelee.disabled = false
			hook_locked = false
		
		if InventoryHelper.is_itemtype_in_inventory(inv, yarn_bag_type):
			$PlayerFSM/Movement/Lasso.disabled = false
			
		if InventoryHelper.is_itemtype_in_inventory(inv, cope_type):
			$PlayerFSM/Abilities/DeepBreath.disabled = false
			
			# So that # of enemies tracker doesn't update until we can actually do the thing
			EnemyManager.deep_breath_unlocked = true
		
		# NOTE: This is commented out on purpose. May disable in future.
		#if InventoryHelper.is_itemtype_in_inventory(inv, dash_type):
			#$PlayerFSM/Movement/Dash.disabled = false
	
	#hook_locked = false
#	can_attack()
	
func _camera_move():
	if !lock_camera:
		camera.global_position = global_position + (get_global_mouse_position() - global_position) * 0.10
		camera.position_smoothing_enabled = true
		
func can_attack():
	fsm.change_state("CanAttack")
	fsm.change_state("Idle")

func _physics_process(delta: float) -> void:
	pass
# Override
func fling():
	pass

# Override
func pull():
	pass

func enter_cutscene(camera_pos : Vector2 = Vector2.INF):
	if camera_pos == Vector2.INF:
		camera_pos = camera.global_position
	
	# hide hp
	get_tree().get_first_node_in_group("gui").hide()
	
	fsm.change_state("NoAttack")
	fsm.change_state("NoDash")
	
	velocity = Vector2.ZERO
	dir = Vector2.ZERO
	
	lock_camera = true
	in_cutscene = true
	
	# since we tween camera pos, position smoothing looks gross. disable until done
	camera.position_smoothing_enabled = false
	
	var cam_tween_vector = camera.global_position - camera_pos
	# travel 2 tiles / sec -- so divide by 48px
	var cam_tween_time = cam_tween_vector.length() / 48.0
	
	var cam_tween = create_tween()
	cam_tween.tween_property(camera, "global_position", camera_pos, cam_tween_time)
	await cam_tween.finished
	
	return
	
func exit_cutscene():
	print("hello!!")
	get_tree().get_first_node_in_group("gui").show()

	#fsm.change_state("Idle")
	fsm.change_state("CanAttack")
	fsm.change_state("CanDash")
	
	lock_camera = false
	in_cutscene = false

	camera.position_smoothing_enabled = true
	camera.global_position = global_position + (get_global_mouse_position() - global_position) * 0.10
	
## To be called within a cutscene to move the player to a specific point.
## [param speed_percentage] A value that represents a percentage of the player's normal walk speed
func do_walk(global_point : Vector2, speed_percentage : float = 1.0):
	# Setting the direction puts player into walk state; this manages all our animations and movement logic
	dir = global_position.direction_to(global_point)
	
	# Scale our player speed based on speed_scaled
	var walk_state = $PlayerFSM/Movement/Walk
	var orig_speed = walk_state.ground_speed
	var speed_scaled = orig_speed * speed_percentage
	walk_state.ground_speed = speed_scaled

	# Calculate how long it will take to get to end based on speed_scaled
	# We do this with a timer so that if player hits a wall on the way, they will still move to the next point
	var distance_to_end = global_position.distance_to(global_point)
	var walk_timer = get_tree().create_timer(distance_to_end / speed_scaled, true)

	# Wait until we "should have" reached the point specified
	await walk_timer.timeout
	
	# Stop moving & reset speed back to default
	dir = Vector2.ZERO
	walk_state.ground_speed = orig_speed
	return

func start_movement_tutorial():
	$MovementKeys.start_tutorial()
	
func _on_health_component_died() -> void:
	set_collision_layer_value(3, false)
	
	var current_dir : Vector2
	var idle := false
	
	for state in $PlayerFSM/Movement.active_states:
		if state == "Idle":
			idle = true
			break;
	
	if idle == true:
		print("Idle Found")
		current_dir = idle_dir
	else: 
		current_dir = dir
	
	$PlayerFSM.change_state("Death", current_dir)

## Checks to see if a player is current standing inside of an EncounterBoundry
## If so, it returns the boundry itself
func check_encounter():
	var areas = $EncounterChecker.get_overlapping_areas()
	if !areas: # Check if null (or empty)
		return null
		
	var area = areas[0]
	if area is EncounterArea:
		return area

## Flashes player to signal they were hit
#func _on_health_component_update_complete() -> void:
	#$HitflashPlayer.play("Hitflash")

func start_invulnerability_effect(duration: float = 1.0, fade_speed: float = 0.15):
	"""
	Makes the character fade in and out to indicate invulnerability
	duration: How long the invulnerability lasts in seconds
	fade_speed: How fast each fade cycle is (lower = faster flashing)
	"""
	if is_invulnerable:
		return  # Already invulnerable, don't restart
	
	is_invulnerable = true
	
	# Create a new tween
	fade_tween = create_tween()
	fade_tween.set_loops()  # Make it loop indefinitely
	
	# Chain fade out and fade in
	fade_tween.tween_property(character_sprite, "modulate:a", 0.3, fade_speed)
	fade_tween.tween_property(character_sprite, "modulate:a", 1.0, fade_speed)
	
	# Stop the effect after the duration
	get_tree().create_timer(duration).timeout.connect(_end_invulnerability_effect)

func _end_invulnerability_effect():
	"""
	Stops the fade effect and ensures character is fully visible
	"""
	is_invulnerable = false
	
	if fade_tween:
		fade_tween.kill()
	
	# Ensure character is fully opaque
	var end_tween = create_tween()
	end_tween.tween_property(character_sprite, "modulate:a", 1.0, 0.1)
	
func _on_animation_player_current_animation_changed(name: String) -> void:
	$Hook/CollisionPolygon2D.set_deferred("disabled", true)
