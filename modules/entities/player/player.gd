extends TetherableBody

# All the logic is handled by the xsm below
# Even variables have now been moved to states
# Player keeps it own velocity, as well as vars that can be used by many different states
var lock_camera := false
var dir : Vector2 = Vector2.ZERO

# swing_dir is a variable updated by our hook swing that gets the 
# nearest cardinal direction to our mouse click (n, e, s, w)
# we keep it in here to use it to push blocks in that direction
var swing_dir : Vector2

# if player is currently inside a "ledge" area, the reference to that is stored here
var ledge_collision : Area2D

var hook_locked := true

# this is to pass unhandled input to states
signal unhandled_input_received(event)

@onready var health_component = $HealthComponent

var curr_camera_boundry : Area2D

func _unhandled_input(event: InputEvent) -> void:
	dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_camera_move()
	unhandled_input_received.emit(event)
	
func _process(_delta):	
	# Camera Boundries MUST NOT overlap eachother, and must have the collision\
	# layer 9 (i.e., "CameraBoundryCollider").
	
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
	hook_locked = false
	can_attack()
	
func _camera_move():
	if !lock_camera:
		$Camera2D.global_position = global_position + (get_global_mouse_position() - global_position) * 0.25
		$Camera2D.position_smoothing_enabled = true
	else:
		$Camera2D.position_smoothing_enabled = false
		
func can_attack():
	$PlayerFSM.change_state("CanAttack")
	$PlayerFSM.change_state("Idle")

# Override
func fling():
	pass

# Override
func pull():
	pass
