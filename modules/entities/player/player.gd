extends CharacterBody2D

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

@onready var health_component = $HealthComponent
@onready var yarn_raycast = $YarnRayCast2D

func _process(_delta):
	_camera_move(_delta)

func _physics_process(delta: float) -> void:
	# Rotate the raycast toward the mouse
	var mouse_pos = get_global_mouse_position() + Vector2(0, 8)
	var attack_dir = global_position.direction_to(mouse_pos).normalized()
	yarn_raycast.rotation = Vector2.ZERO.angle_to_point(attack_dir)

func _camera_move(_delta):
	if !lock_camera:
		$Camera2D.global_position = round(global_position + (get_global_mouse_position() - global_position) * 0.25)
		$Camera2D.position_smoothing_enabled = true
	else:
		$Camera2D.position_smoothing_enabled = false
	
