extends StateSound

@onready var yarn_proj = $"../../../YarnProj"
@onready var projectile = $"../../../YarnProj/Projectile"

var current_dist := 0.0
var speed := 325.0
var casting := true
var tethered_body : CharacterBody2D

func _on_enter(_args) -> void:
	# Rotate the yarn projectile toward the mouse
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var dir = target.global_position.direction_to(mouse_pos).normalized()
	yarn_proj.rotation = Vector2.ZERO.angle_to_point(dir)
	
	tethered_body = null
	casting = true

func _on_update(delta: float) -> void:
	# yarn is frogged or snaps from tension or otherwise breaks
	if (current_dist >= target.yarn_length):
		casting = false
	
	if casting: # Continue the projectile's path
		lasso(delta)
	elif is_instance_valid(tethered_body):
		if current_dist <= 24:
			change_state("Inactive")
			return
		yank(delta)
	else:
		change_state("Inactive")

func lasso(delta:float):
	current_dist += speed * delta
	projectile.position.x = current_dist
	yarn_proj.get_node("Line2D").points[1] = projectile.position

func yank(delta:float):
	var dir = target.global_position.direction_to(tethered_body.global_position).normalized()
	yarn_proj.rotation = Vector2.ZERO.angle_to_point(dir)
	
	tethered_body.global_position -= dir * (speed/2 * delta)
	target.global_position += dir * (speed/2 * delta)
	
	current_dist = target.global_position.distance_to(tethered_body.global_position)
	projectile.position.x = current_dist
	yarn_proj.get_node("Line2D").points[1] = projectile.position

func _on_projectile_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if (!casting):
		return
	
	# Projectile has collided with a tetherable body
	tethered_body = area.get_parent()
	casting = false
	tethered_body.leash_owner = target
	if tethered_body.is_in_group("enemy"):
		tethered_body.tethered_stun()

func _on_exit(_args) -> void:
	# frog
	projectile.position = Vector2.ZERO
	yarn_proj.get_node("Line2D").points = [Vector2.ZERO, Vector2.ZERO]
	tethered_body = null
	
	casting = true
