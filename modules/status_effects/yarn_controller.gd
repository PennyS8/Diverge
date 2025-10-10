extends Node2D

var YARN_LENGTH := 128.0

var proj_distance := 96.0
var current_dist := 0.0
var speed := 325.0

var hold_projectile := false
@export var can_collide := true
var tethered_body

@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	# to dereference the player and abstract the YarnController
	if hold_projectile:
		return
	
	var yarn_end_pos := Vector2.ZERO

	var origin_pos = get_parent().get_node_or_null("%YarnOrigin")
	if origin_pos:
		position = origin_pos.position
	
	if can_collide:
		$Projectile.position.x += speed * delta
		current_dist += speed * delta
		yarn_end_pos = $Projectile.position
	else: # Yarn has collided with a body
		if is_instance_valid(tethered_body):
			current_dist = global_position.distance_to(tethered_body.global_position)
			yarn_end_pos = Vector2(current_dist, 0.0)
			
			# Rotate the yarn projectile toward the mouse
			var tethered_body_parent : Node2D = tethered_body.get_parent()
			var tethered_body_dir
			if tethered_body_parent and ("yarn_endpoint" in tethered_body_parent):
				tethered_body_dir = tethered_body_parent.to_global(tethered_body_parent.yarn_endpoint)
			else:
				tethered_body_dir = tethered_body.global_position
			var dir = global_position.direction_to(tethered_body_dir).normalized()
			global_rotation = Vector2.ZERO.angle_to_point(dir)
		else:
			if get_parent().is_in_group("player"):
				get_parent().get_node("PlayerFSM").change_state("Recall")
			queue_free()
	
	$Line2D.points[1] = yarn_end_pos
	$RayCast2D.target_position = yarn_end_pos
	
	# Base case, yarn is recalled or snaps from tension
	if (
		current_dist >= YARN_LENGTH or
		Input.is_action_just_pressed("recall") #or
		#$RayCast2D.get_collider() != tethered_body
	):
		if get_parent().is_in_group("player"):
			get_parent().get_node("PlayerFSM").change_state("Recall")
		queue_free()

func _on_projectile_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	## Do not collide with parent
	if _body == get_parent():
		return
	
	if get_parent() == player:
		player.can_attack()
		
	can_collide = false
	$Projectile.queue_free()
	

func _on_projectile_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	# Do not collide with parent
	if area == get_parent():
		return
	
	if get_parent() == player:
		player.can_attack()
	
	if (
		area == player or
		!can_collide or
		!area.get_parent().is_in_group("tetherable_body")
	): # Do NOT collide if any of the above conditions are true
		can_collide = false
		$Projectile.queue_free()
		return
	
	# Projectile has collided with a tetherable body
	
	can_collide = false
	tethered_body = area
	
	player.add_tethered_status()
	area.get_parent().add_tethered_status()
	area.get_parent().leash_owner = player
	
	if (area.get_parent().is_in_group("enemy")):
		area.get_parent().tethered_stun()
	$Projectile.queue_free()

## Check for wall collisions
func _on_wall_detector_body_shape_entered(body):
	if !get_node_or_null("Projectile"):
		return
	
	## Do not collide with parent
	if body == get_parent():
		return
	
	if get_parent() == player:
		player.can_attack()
		
	can_collide = false
	$Projectile.queue_free()
	
