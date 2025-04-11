extends TetherableBody

# Most logic is handled by the xsm below
# Player keeps it own velocity, as well as vars that can be used by many different states

var lock_camera := false
var in_cutscene := false
var cutscene_walk_to_position := Vector2.ZERO

var dir : Vector2 = Vector2.ZERO

var dialogue_open : bool = false
# swing_dir is a variable updated by our hook swing that gets the 
# nearest cardinal direction to our mouse click (n, e, s, w)
# we keep it in here to use it to push blocks in that direction
var swing_dir : Vector2

# if player is currently inside a "ledge" area, the reference to that is stored here
var ledge_collision : Area2D

var hook_locked := false

# this is to pass unhandled input to states
signal unhandled_input_received(event)

@onready var health_component = $HealthComponent
var curr_camera_boundry : Area2D
@onready var anim_player = $AnimationPlayer
@onready var camera : Camera2D = $Camera2D
@onready var fsm : State = $PlayerFSM

var cutscene_marker_packed = preload("res://modules/objects/debug/cutscene_walk_point.tscn")

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
	if !lock_camera:
		var areas = $Area2D.get_overlapping_areas()
		if !areas: # Check if null (or empty)
			return
		
		var area = areas[0]
		if area != curr_camera_boundry: # Only set the camera limits once
			curr_camera_boundry = area
			
			var top_right : Vector2 = area.get_node("LimitTopRight").global_position
			var bottom_left : Vector2 = area.get_node("LimitBottomLeft").global_position
			$Camera2D.limit_top = top_right.y
			$Camera2D.limit_right = top_right.x
			$Camera2D.limit_bottom = bottom_left.y
			$Camera2D.limit_left = bottom_left.x

func check_unlock_hook():
	var deinv : RestrictedInventory = load("res://modules/ui/hud/wyvern_inv/equipment_inventory.tres")
	#hook_locked = false
#	can_attack()
	
func _camera_move():
	if !lock_camera:
		$Camera2D.global_position = global_position + (get_global_mouse_position() - global_position) * 0.25
		$Camera2D.position_smoothing_enabled = true
		
func can_attack():
	$PlayerFSM.change_state("CanAttack")
	$PlayerFSM.change_state("Idle")

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
	cam_tween.tween_property($Camera2D, "global_position", camera_pos, cam_tween_time)
	await cam_tween.finished
	
	camera.position_smoothing_enabled = true
	return
	
func exit_cutscene():
	print("hello!!")
	get_tree().get_first_node_in_group("gui").show()

	$PlayerFSM.change_state("Idle")
	fsm.change_state("CanAttack")
	fsm.change_state("CanDash")
	
	lock_camera = false
	in_cutscene = false
	camera.global_position = global_position + (get_global_mouse_position() - global_position) * 0.25
	
func do_walk(global_point : Vector2, speed_percentage : float = 1.0):
	# setting dir puts player into walk state; this manages all our animations and logic and stuff
	dir = global_position.direction_to(global_point)
	
	var cutscene_marker : Area2D = cutscene_marker_packed.instantiate()
	get_tree().current_scene.add_child(cutscene_marker)
	
	cutscene_marker.global_position = global_point
	
	await cutscene_marker.body_entered
	dir = Vector2.ZERO
	return
