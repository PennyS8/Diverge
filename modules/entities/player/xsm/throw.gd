@tool
extends StateSound

var thread_aim_guide = preload("res://modules/status_effects/thread_aim_guide.tscn")
const YARN_LENGTH = 64
var tethered_node
var guide_arrow
var arrow_point

@onready var status_holder = $"../../../StatusHolder"

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	# Find the targeted tethered node (not the player)
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	tethered_node = tethered_nodes[0]
	if tethered_node.is_in_group("player"):
		tethered_node = tethered_nodes[1]
	
	# Define the guide arrow to help the player aim their throw
	guide_arrow = thread_aim_guide.instantiate()
	target.add_child(guide_arrow)

func _on_update(delta: float) -> void:
	if Input.is_action_just_released("throw"):
		change_state("Idle")
	
	if !target.get_node("AimGuide"):
		# Define the guide arrow to help the player aim their throw
		guide_arrow = thread_aim_guide.instantiate()
		target.add_child(guide_arrow)
	
	# Establish vars to define guide_arrow
	var mouse_pos = target.get_global_mouse_position()
	arrow_point = mouse_pos
	var dist = tethered_node.global_position.distance_to(mouse_pos)
	
	# Adjust values to not exceed the YARN_LENGTH limit
	if dist > YARN_LENGTH:
		arrow_point = tethered_node.global_position.lerp(mouse_pos, YARN_LENGTH/dist)
		dist = YARN_LENGTH
	
	# Place the arrow head at the mouse position
	guide_arrow.global_position = arrow_point
	# Draw a line from the node to the arrow head
	guide_arrow.get_node("Line2D").points[0] = Vector2(-dist, 0)
	# Rotate the arrow to point at the mouse position
	var realtive_pos = tethered_node.to_local(arrow_point)
	var arrow_rotation = Vector2.ZERO.angle_to_point(realtive_pos)
	guide_arrow.rotation = arrow_rotation

func _on_exit(_args) -> void:
	guide_arrow.queue_free()
	
	var mouse_pos = target.get_global_mouse_position()
	
	# Check for selected node in range to collide with node being thrown
	var dist = tethered_node.global_position.distance_to(mouse_pos)
	var selected_node = get_tree().get_first_node_in_group("selected")
	if dist <= YARN_LENGTH and selected_node:
		status_holder.remove_status("Tethered")
		
		selected_node.get_node("StatusHolder").deselect()
		selected_node.get_node("StatusHolder").add_status("tethered")
		selected_node.get_node("StatusHolder").pull_tethered_node()
	# Throw tethered body to arrow_point
	else:
		tethered_node.get_node("StatusHolder").fling_tethered_node(arrow_point)
		StatusEffectsManager.thread_line2d.queue_free()
		status_holder.remove_status("Tethered")
	
	change_state("CanAttack")
