extends TetherableBody

# Most logic is handled by the xsm below
# Player keeps it own velocity, as well as vars that can be used by many different states

var hook_locked := false
var lock_camera := false
var in_cutscene := false
var dialogue_open := false
var cutscene_walk_to_position := Vector2.ZERO
var dir := Vector2.ZERO
var swing_dir : Vector2 # Cardinal dir of attack
var ledge_collision : Area2D # reference to the ledge_area player is in
var curr_camera_boundry : Area2D

# this is to pass unhandled input to states
signal unhandled_input_received(event)

@onready var health_component = $HealthComponent
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var camera : Camera2D = $Camera2D
@onready var fsm : State = $PlayerFSM

var cutscene_marker_packed = preload("res://modules/objects/debug/cutscene_walk_point.tscn")

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(dialogue_done)
	
func dialogue_done(_resource : Resource) -> void:
	dialogue_open = false

func _unhandled_input(event: InputEvent) -> void:
	unhandled_input_received.emit(event)
	if !in_cutscene:
		_camera_move()
		dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _process(_delta):
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
			camera.limit_top = top_right.y
			camera.limit_right = top_right.x
			camera.limit_bottom = bottom_left.y
			camera.limit_left = bottom_left.x

func check_unlock_hook():
	@warning_ignore("unused_variable")
	var deinv : RestrictedInventory = load("res://modules/ui/hud/wyvern_inv/equipment_inventory.tres")
	#hook_locked = false
	#can_attack()

func _camera_move():
	if !lock_camera:
		var relative_mouse_pos = get_global_mouse_position() - global_position
		camera.global_position = global_position + (0.1*relative_mouse_pos)
		camera.position_smoothing_enabled = true
		
func can_attack():
	fsm.change_state("CanAttack")
	fsm.change_state("Idle")

# Override
func fling():
	pass

# Override
func pull():
	pass

func enter_cutscene(camera_pos):
	# hide hp
	get_tree().get_first_node_in_group("gui").hide()
	
	fsm.change_state("NoAttack")
	fsm.change_state("NoDash")
	
	velocity = Vector2.ZERO
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
	
	camera.position_smoothing_enabled = true
	return
	
func exit_cutscene():
	get_tree().get_first_node_in_group("gui").show()
	fsm.change_state("Idle")
	fsm.change_state("CanAttack")
	fsm.change_state("CanDash")
	
	lock_camera = false
	in_cutscene = false
	var relative_mouse_pos = get_global_mouse_position() - global_position
	camera.global_position = global_position + (0.25*relative_mouse_pos)
	
func do_walk(global_point : Vector2, _speed_percentage : float = 1.0):
	# setting dir puts player into walk state; this manages all our animations and logic and stuff
	dir = global_position.direction_to(global_point)
	
	var cutscene_marker : Area2D = cutscene_marker_packed.instantiate()
	get_tree().current_scene.add_child(cutscene_marker)
	
	cutscene_marker.global_position = global_point
	
	await cutscene_marker.body_entered
	dir = Vector2.ZERO
