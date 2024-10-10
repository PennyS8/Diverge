@tool
extends StateSound


@export var dash_speed = 1000
@export var dash_distance = 128
@export var exit_air_speed = 300
@export var exit_ground_speed = 450


var last_frame_pos := Vector2()
var dash_current_length := 0.0
var dash_direction := Vector2()

# FUNCTIONS AVAILABLE TO INHERIT
func _on_enter(_args) -> void:
	# var move_sound = target.get_node("Sounds/DashSound")
	# move_sound.play()
	# move_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5

	target.velocity = Vector2()
	last_frame_pos = target.global_position

	# Finding the dash direction
	var input_left = Input.is_action_pressed("ui_left")
	var input_right = Input.is_action_pressed("ui_right")
	var input_up = Input.is_action_pressed("ui_up")
	var input_down = Input.is_action_pressed("ui_down")
	if not input_left \
			and not input_right \
			and not input_up \
			and not input_down:
		dash_direction.x = target.skin.scale.x
	else:
		if input_up:
			dash_direction.y = - 1
		elif input_down:
			dash_direction.y = 1
		if input_left:
			dash_direction.x = - 1
		elif input_right:
			dash_direction.x = 1
		if (target.is_on_floor() and dash_direction.y > 0):
			dash_direction.x = target.skin.scale.x
	dash_direction = dash_direction.normalized()

	target.get_node("DashParticles2D").emitting = true
	target.get_node("DashParticles2D").rotation = - dash_direction.angle_to(Vector2.UP)
	target.get_node("DashParticles2D").position = - dash_direction * 10

	target.skin.rotation = - dash_direction.angle_to(Vector2.UP)

	var _st = change_state("NoDash")


func _after_update(_delta) -> void:
	# Yeah this whole thing was to create a smart dash
	# THis dash changes direction when it touches an object
	# Overkill for this example but was fun to do ;)
	if target.is_on_wall():
		target.detect_wall_dir()
		if sign(dash_direction.x) == target.wall_dir:
			target.position.x -= target.wall_dir
			target.skin.scale.x = - target.wall_dir
			if target.is_on_floor():
				dash_direction = Vector2.UP
			elif target.is_on_ceiling():
				dash_direction = Vector2.DOWN
			elif Input.is_action_pressed("ui_down"):
				dash_direction = Vector2.DOWN
			else:
				dash_direction = Vector2.UP
	elif target.is_on_floor() and dash_direction.y > 0:
		target.position.y -= 1
		dash_direction.y = 0
		if target.dir != 0:
			dash_direction.x = target.dir
		else:
			dash_direction.x = target.skin.scale.x
	elif target.is_on_ceiling() and dash_direction.y < 0:
		target.position.y += 1
		dash_direction.y = 0
		if target.dir != 0:
			dash_direction.x = target.dir
		else:
			dash_direction.x = target.skin.scale.x

	target.velocity = dash_direction * dash_speed

	# Adds fancy particles, because, huh why not ?
	target.get_node("DashParticles2D").rotation = - dash_direction.angle_to(Vector2.UP)
	target.get_node("DashParticles2D").position = - dash_direction * 10
	target.skin.rotation = - dash_direction.angle_to(Vector2.UP)

	# Here, exits if the dash is blocked or if it is too long
	dash_current_length += last_frame_pos.distance_to(target.global_position)
	if dash_current_length > 0 and last_frame_pos == target.global_position:
		var _st = change_state("Fall")
	last_frame_pos = target.global_position
	if dash_current_length >= dash_distance - dash_speed * _delta:
		var _st = change_state("Fall")


func _on_exit(_args) -> void:
	if dash_direction.y < 0:
		target.velocity = exit_air_speed * dash_direction
	else:
		target.velocity = exit_ground_speed * dash_direction
		# move down by one pixel to the ground if it is just above it
		var raysult = target.ray(target.skin.scale.x, target.BOTTOM, 2.0)
		if not raysult.is_empty():
			target.position.y += 1
		
	dash_direction = Vector2()
	dash_current_length = 0.0

	target.get_node("DashParticles2D").emitting = false
	target.get_node("DashParticles2D").rotation = 0
	target.skin.rotation = 0
