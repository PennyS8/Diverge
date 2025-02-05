extends Node2D

var YARN_LENGTH := 128.0

var proj_distance := 96.0
var current_dist := 0.0
var speed := 325.0

var hold_projectile := false
var can_collide := true
var tethered_body

@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if hold_projectile:
		return
	
	var yarn_end_pos := Vector2.ZERO
	
	if can_collide:
		$Projectile.position.x += speed * delta
		current_dist += speed * delta
		yarn_end_pos = $Projectile.position
	
	# Yarn has collided with a body
	else:
		if is_instance_valid(tethered_body):
			current_dist = global_position.distance_to(tethered_body.global_position)
			yarn_end_pos = Vector2(current_dist, 0.0)
			
			# Rotate the yarn projectile toward the mouse
			var tethered_body_dir = tethered_body.global_position - Vector2(0, -8)
			var dir = get_parent().global_position.direction_to(tethered_body_dir).normalized()
			global_rotation = Vector2.ZERO.angle_to_point(dir)
		else:
			if get_parent().is_in_group("player"):
				get_parent().get_node("PlayerFSM").change_state("Recall")
			queue_free()
			
	
	$Line2D.points[1] = yarn_end_pos
	
	# Base case, yarn is recalled or snaps from tension
	if current_dist >= YARN_LENGTH or Input.is_action_just_pressed("recall"):
		if get_parent().is_in_group("player"):
			get_parent().get_node("PlayerFSM").change_state("Recall")
		queue_free()

func _on_projectile_area_entered(area):
	if !can_collide:
		return
	
	# if we collide with the player
	if area.get_parent().get_parent() == player:
		return
	
	# if we collide with self
	#if area.get_parent().get_parent() == self:
		#return
	
	can_collide = false
	tethered_body = area
	
	if get_parent() == player:
		player.can_attack()
	
	get_parent().status_holder.add_status("tethered")
	area.get_parent().add_status("tethered")
	
	$Projectile.queue_free()
