extends StateSound

@onready var yarn_proj = $"../../../YarnProj"
@onready var projectile = $"../../../YarnProj/Projectile"

var proj_distance := 96.0
var current_dist := 0.0
var speed := 325.0
var can_collide := true
var tethered_body

func _on_enter(_args) -> void:
	# Rotate the yarn projectile toward the mouse
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var dir = target.global_position.direction_to(mouse_pos).normalized()
	yarn_proj.rotation = Vector2.ZERO.angle_to_point(dir)
	
	current_dist = 0.0

func _on_update(delta: float) -> void:
	# yarn is frogged or snaps from tension or otherwise breaks
	if (
		current_dist >= target.yarn_length or
		Input.is_action_just_pressed("frog") or
		!can_collide and !is_instance_valid(tethered_body) #or
		#$RayCast2D.get_collider() != tethered_body
	):
		exit()
		return
	
	# Calculate yarn end point position
	var yarn_end_pos := Vector2.ZERO
	
	# Continue the projectile's path
	if can_collide:
		current_dist += speed * delta
		projectile.position.x = current_dist
		yarn_end_pos = projectile.position
	
	# update yarn end point to follow targeted body
	elif is_instance_valid(tethered_body):
		current_dist = yarn_proj.global_position.distance_to(tethered_body.global_position)
		yarn_end_pos = Vector2(current_dist, 0.0)
		
		var dir = target.global_position.direction_to(tethered_body.global_position).normalized()
		yarn_proj.global_rotation = Vector2.ZERO.angle_to_point(dir)
	
	# Set updated values
	yarn_proj.get_node("Line2D").points[1] = yarn_end_pos
	projectile.position = yarn_end_pos
	yarn_proj.get_node("RayCast2D").target_position = yarn_end_pos

func _on_exit(_args) -> void:
	# frog
	yarn_proj.get_node("Line2D").points = [Vector2(0, 0), Vector2(0, 0)]
	projectile.position = Vector2(0, 0)
	yarn_proj.get_node("RayCast2D").target_position = Vector2(0, 0)
	tethered_body = null

func _on_projectile_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if (!can_collide):
		return
	
	# Projectile has collided with a tetherable body
	tethered_body = area.get_parent()
	can_collide = false
	tethered_body.leash_owner = target
	if tethered_body.is_in_group("enemy"):
		tethered_body.tethered_stun()
