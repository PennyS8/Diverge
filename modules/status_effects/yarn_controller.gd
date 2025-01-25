extends Node2D

var proj_distance := 96.0
var current_dist := 0.0
var speed := 325.0

var can_collide := true
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	$Projectile.position.x += speed * delta
	current_dist += speed * delta
	$Line2D.points[1] = $Projectile.position
	if current_dist >= proj_distance or Input.is_action_just_pressed("recall"):
		if get_parent().is_in_group("player"):
			get_parent().can_attack()
		queue_free()
	
	


func _on_projectile_area_entered(area):
	if !can_collide:
		return
	
	# if we collide with the player	
	if area.get_parent().get_parent() == player:
		return
		
	can_collide = false
	
	if get_parent() == player:
		player.can_attack()
		
	area.get_parent().add_status("tethered")
	get_parent().status_holder.add_status("tethered")
	
	queue_free()


func _on_line_2d_draw():
	pass # Replace with function body.
