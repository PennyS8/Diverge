extends State

var yarn_aim_guide = preload("res://modules/entities/player/yarn/yarn_controller.tscn")
var guide_arrow
var arrow_point

var tethered_body : TetherableBody

func update_guide_arrow(dist, mouse_pos):
	# Define the guide arrow to help the player aim their throw
	if !target.get_node_or_null("AimGuide"):
		guide_arrow = yarn_aim_guide.instantiate()
		target.add_child(guide_arrow) # TODO: show yarn above player
	
	# Adjust values to not exceed the yarn_length limit
	if dist > target.yarn_length:
		arrow_point = tethered_body.global_position.lerp(mouse_pos, target.yarn_length/dist)
		dist = target.yarn_length
	else:
		arrow_point = mouse_pos
	
	# Place the arrow head at the mouse position
	guide_arrow.global_position = arrow_point
	# Draw a line from the node to the arrow head
	guide_arrow.get_node("Line2D").points[0] = Vector2(-dist, 0)
	# Rotate the arrow to point at the mouse position
	var realtive_pos = tethered_body.to_local(arrow_point)
	var arrow_rotation = Vector2.ZERO.angle_to_point(realtive_pos)
	guide_arrow.rotation = arrow_rotation
