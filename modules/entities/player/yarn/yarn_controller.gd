extends Node2D

var proj_distance := 96.0
var current_dist := 0.0
var speed := 325.0

var can_collide := true
@onready var yarn = LevelManager.player.get_node("PlayerFSM/Abilities/Yarn")

@onready var player = LevelManager.player
@onready var init_pos = self.global_position

func _process(delta):
	var yarn_end_pos := Vector2.ZERO
	
	# yarn is frogged or snaps from tension or otherwise breaks
	if (
		current_dist >= player.yarn_length or
		Input.is_action_just_pressed("frog") or
		!can_collide and !is_instance_valid(yarn.tethered_body) #or
		#$RayCast2D.get_collider() != tethered_body
	):
		player.get_node("PlayerFSM").change_state("Frog")
		queue_free()
	
	# Continue the projectile's path
	if can_collide:
		$Projectile.position.x += speed * delta
		current_dist += speed * delta
		yarn_end_pos = $Projectile.position
	
	# Rotate the yarn projectile toward the tethered_body
	elif is_instance_valid(yarn.tethered_body):
		current_dist = global_position.distance_to(yarn.tethered_body.global_position)
		yarn_end_pos = Vector2(current_dist, 0.0)
		
		var dir = get_parent().global_position.direction_to(yarn.tethered_body.global_position).normalized()
		global_rotation = Vector2.ZERO.angle_to_point(dir)
	
	$Line2D.points[1] = yarn_end_pos
	$RayCast2D.target_position = yarn_end_pos

func _on_projectile_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	
	if (!can_collide):
		$Projectile.queue_free()
		return
	
	# Projectile has collided with a tetherable body
	yarn.tethered_body = _area.get_parent()
	tether_object(yarn.tethered_body)

func tether_object(body:CharacterBody2D):
	can_collide = false
	
	body.add_tethered_status()
	body.leash_owner = player
	
	if body.is_in_group("enemy"):
		body.tethered_stun()
	
	$Projectile.queue_free()

## Check for wall collisions
func _on_wall_detector_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	can_collide = false
	$Projectile.queue_free()
