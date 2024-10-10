@tool
extends State


@export var air_speed := 300.0
@export var air_accel := 6.0
@export var air_friction := 10.0


# FUNCTIONS TO INHERIT #
func _on_enter(_args):
	if target.is_on_floor():
		var _s = change_state("OnGround")


func _on_update(delta):

	if target.dir != 0:
		target.velocity.x = lerp(target.velocity.x, air_speed * target.dir, air_accel * delta)
	else:
		target.velocity.x = lerp(target.velocity.x,  0.0, air_friction * delta)

	target.skin.rotation = - target.velocity.angle_to(Vector2.UP)

	if target.is_on_floor():
		var _s = change_state("OnGround")
	elif target.is_on_wall():
		target.detect_wall_dir()

		# If is almost on top of the wall, climb the corner
		# Otherwise, go on wall
		var result = target.ray(target.wall_dir, target.TOP_FRONT, 1.1)
		if result.is_empty():
			var _s = change_state("CornerHop")
		else:
			var _s = change_state("OnWall")


func _on_exit(_args) -> void:
	target.skin.rotation = 0
