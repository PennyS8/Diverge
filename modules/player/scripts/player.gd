extends CharacterBody2D

# All the logic is handled by the xsm below
# Even variables have now been moved to states
# Player keeps it own velocity, as well as vars that can be used by many different states

var dir : Vector2 = Vector2.ZERO
var swing_dir : Vector2

func _physics_process(delta):
	_camera_move(delta)
	
func _camera_move(delta):
	$Camera2D.global_position = global_position + (get_global_mouse_position() - global_position) * 0.25

func _on_sword_body_entered(body: Node2D) -> void:
	if body.is_in_group("block"):
		body.push(swing_dir)
	elif body.is_in_group("lever"):
		body.flip()
	elif body.is_in_group("barrel"):
		body.hit(1)
