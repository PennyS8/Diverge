@tool
extends StateSound

var thread_aim_guide = preload("res://modules/status_effects/thread_aim_guide.tscn")
var tethered_node
var guide_arrow
var arrow_point
const YARN_LENGTH = 96 # 64 + 32

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
	# These vars declared here because they're needed if we grapple an anchor
	var mouse_pos = target.get_global_mouse_position()
	var dist = tethered_node.global_position.distance_to(mouse_pos)
	
	if Input.is_action_just_released("throw"):
		# If player has tethered an anchor ONLY, change to grapple state
		var selected_node = get_tree().get_first_node_in_group("selected")
		if !(dist <= YARN_LENGTH and selected_node):
			if tethered_node.is_in_group("anchor"):
				change_state("Grapple", tethered_node)
				return
		
		# Otherwise change to idle state
		change_state("Idle")
	
	# Define the guide arrow to help the player aim their throw
	if !target.get_node("AimGuide"):
		guide_arrow = thread_aim_guide.instantiate()
		target.add_child(guide_arrow)
	
	# Adjust values to not exceed the YARN_LENGTH limit
	if dist > YARN_LENGTH:
		arrow_point = tethered_node.global_position.lerp(mouse_pos, YARN_LENGTH/dist)
		dist = YARN_LENGTH
	else:
		arrow_point = mouse_pos
	
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
	
	# Check for selected node in range to collide with node being thrown
	var selected_node = get_tree().get_first_node_in_group("selected")
	
	# Disallow the player to lasso a body to an anchor
	if selected_node:
		if selected_node.is_in_group("anchor"):
			selected_node = null
		else:
			# Apply tethered status to selected_node
			selected_node.get_node("StatusHolder").add_status("tethered")
	
	var mouse_pos = target.get_global_mouse_position()
	var dist = tethered_node.global_position.distance_to(mouse_pos)
	# Pull the tethered_node and the selected_node toward eachother, if able
	if dist <= YARN_LENGTH and selected_node:
		status_holder.remove_status("tethered")
		
		selected_node.get_node("StatusHolder").deselect()
		
		selected_node.get_node("StatusHolder").pull_tethered_node()
		tethered_node.get_node("StatusHolder").pull_tethered_node()
		
		selected_node.get_node("StatusHolder").remove_status("tethered")
		tethered_node.get_node("StatusHolder").remove_status("tethered")
	# Pull the tethered body to the player, or the player to an anchor
	else:
		if !tethered_node.is_in_group("anchor"):
			tethered_node.get_node("StatusHolder").fling_tethered_node()
		else:
			# The player is already transitioning to the grapple state
			status_holder.remove_status("tethered")
	
	StatusEffectsManager.thread_line2d.queue_free()
	change_state("CanAttack")
