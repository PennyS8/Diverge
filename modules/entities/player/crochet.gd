@tool
extends StateSound

@onready var yarn = $"../../../Yarn"
@onready var projectile = %YarnProjectile
@onready var wall_detector = %WallDetector

var current_dist := 0.0
var speed := 240.0
var casting := true
var tethered_body : CharacterBody2D

var player_height_offset : Vector2
var player_center_pos : Vector2
var tethered_height_offset : Vector2
var tethered_center_pos : Vector2

func _on_enter(_args) -> void:
	player_height_offset = Vector2(0, target.yarn_height)
	
	# Rotate the yarn projectile toward the mouse
	player_center_pos = target.global_position - player_height_offset
	var mouse_pos := target.get_global_mouse_position()
	var dir := player_center_pos.direction_to(mouse_pos).normalized()
	yarn.rotation = Vector2.ZERO.angle_to_point(dir)
	
	current_dist = 0.0
	tethered_body = null
	casting = true
	
	projectile.monitorable = true
	projectile.monitoring = true
	
	wall_detector.monitorable = true
	wall_detector.monitoring = true

func _on_update(delta:float) -> void:
	# yarn is frogged or snaps from tension or otherwise breaks
	if (current_dist >= target.yarn_length):
		casting = false
	
	if casting: # Continue the projectile's path
		lasso(delta)
	elif is_instance_valid(tethered_body):
		if current_dist <= 24:
			exit()
			return
		yank(delta, tethered_body.weight)
	else:
		if current_dist <= 12:
			exit()
			return
		recoil(delta)

func lasso(delta:float):
	current_dist += speed * delta
	projectile.position.x = current_dist
	yarn.get_node("Line2D").points[1].x = current_dist

func yank(delta:float, tethered_body_weight:float):
	var sum_weight = target.weight + tethered_body_weight
	tethered_height_offset = Vector2(0, tethered_body.yarn_height)
	
	tethered_center_pos = tethered_body.global_position - tethered_height_offset
	player_center_pos = target.global_position - player_height_offset
	var dir = player_center_pos.direction_to(tethered_center_pos).normalized()
	
	yarn.rotation = Vector2.ZERO.angle_to_point(dir)
	var base_speed = dir*speed*delta
	
	if tethered_body_weight < 0:
		target.global_position += base_speed
	else:
		tethered_body.global_position -= base_speed * (target.weight/sum_weight)
		target.global_position += base_speed * (tethered_body_weight/sum_weight)
	
	current_dist = player_center_pos.distance_to(tethered_center_pos)
	projectile.position.x = current_dist
	yarn.get_node("Line2D").points[1].x = current_dist

func recoil(delta:float):
	current_dist -= (speed * delta)
	projectile.position.x = current_dist
	yarn.get_node("Line2D").points[1].x = current_dist

func _on_projectile_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if (!casting):
		return
	
	# Projectile has collided with a tetherable body
	tethered_body = area.get_parent()
	casting = false
	#tethered_body.leash_owner = target
	if tethered_body.is_in_group("enemy"):
		tethered_body.tethered_stun()

func _on_wall_detector_body_entered(_body: Node2D) -> void:
	casting = false
	tethered_body = null

func _on_exit(_args) -> void:
	# frog
	yarn.rotation = 0
	yarn.get_node("Line2D").points[1].x = 0
	projectile.position.x = 0
	tethered_body = null
	current_dist = 0.0
	casting = true
	
	projectile.monitorable = false
	projectile.monitoring = false
	
	wall_detector.monitorable = false
	wall_detector.monitoring = false
