extends CharacterBody2D

# All the logic is handled by the xsm below
# Even variables have now been moved to states
# Player keeps it own velocity, as well as vars that can be used by many different states

var dir : Vector2 = Vector2.ZERO

# swing_dir is a variable updated by our sword swing that gets the 
# nearest cardinal direction to our mouse click (n, e, s, w)
# we keep it in here to use it to push blocks in that direction
var swing_dir : Vector2

@onready var health_component = $HealthComponent

var lock_camera := false

func _process(delta):
	_camera_move(delta)
	$Camera2D.position = round($Camera2D.position)

func _camera_move(delta):
	if !lock_camera:
		$Camera2D.global_position = global_position + (get_global_mouse_position() - global_position) * 0.25
		$Camera2D.position_smoothing_enabled = true
	else:
		$Camera2D.position_smoothing_enabled = false

func _on_sword_body_entered(body: Node2D) -> void:
	if body.is_in_group("block"):
		body.push(swing_dir)
	elif body.is_in_group("lever"):
		body.flip()
	elif body.is_in_group("barrel"):
		body.hit(1)
