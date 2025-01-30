@tool
extends StateSound

var yarn_aim_guide = preload("res://modules/status_effects/yarn_aim_guide.tscn")
var guide_arrow
var arrow_point

var tethered_node
var selected_node

var hold_counter : float = 0.0
const HOLD_TIME : float = 0.15

const YARN_LENGTH = 96 # 64 + 32

@onready var status_holder = $"../../../StatusHolder"

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	hold_counter = 0.0
	
	# Find the targeted tethered node (not the player)
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	tethered_node = tethered_nodes[0]
	if tethered_node.is_in_group("player"):
		tethered_node = tethered_nodes[1]

func _on_update(delta: float) -> void:
	if Input.is_action_pressed("throw"):
		hold_counter += delta
	
	if tethered_node.is_in_group("lever"):
		change_state("Idle")
		return
	
	# These vars declared here because they're needed if we grapple an anchor
	var mouse_pos = target.get_global_mouse_position()
	var dist = tethered_node.global_position.distance_to(mouse_pos)
	
	if Input.is_action_just_released("throw"):
		# Find the targeted tethered node (not the player)
		var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
		var tethered_node = tethered_nodes[0]
		if tethered_node.is_in_group("player"):
			tethered_node = tethered_nodes[1]
			
		# If the player has tethered ONLY an anchor, then grapple the anchor
		selected_node = get_tree().get_first_node_in_group("selected")
		if !(dist <= YARN_LENGTH and selected_node):
			if tethered_node.is_in_group("anchor"):
				if hold_counter >= HOLD_TIME:
					pass
				else:
					change_state("Grapple", tethered_node)
					return
		# Otherwise exit throw state normally
		change_state("Idle")
		return
	
	# Draw a guide arrow if the "throw" button is being held down
	if hold_counter >= HOLD_TIME:
		update_guide_arrow(dist, mouse_pos)

func _on_exit(_args) -> void:
	if guide_arrow: # Remove the guide arrow
		guide_arrow.queue_free()
		guide_arrow = null
	
	# Check for valid selected node in range to collide with node being thrown
	if selected_node:
		var dist = tethered_node.global_position.distance_to(selected_node.global_position)
		if (
			selected_node.is_in_group("lever") or
			tethered_node.is_in_group("lever") or
			dist > YARN_LENGTH
		):
			selected_node = null
		else:
			selected_node.get_node("StatusHolder").add_status("tethered")
	
	# Pull the tethered_node and the selected_node toward eachother, if able
	if selected_node:
		status_holder.remove_status("tethered")
		target.get_node("YarnController").queue_free()
		
		selected_node.get_node("StatusHolder").deselect()
		
		selected_node.get_node("StatusHolder").pull_tethered_node()
		tethered_node.get_node("StatusHolder").pull_tethered_node()
		
		selected_node.get_node("StatusHolder").remove_status("tethered")
		tethered_node.get_node("StatusHolder").remove_status("tethered")
	
	# Pull the tethered body to the player, or the player to an anchor
	elif !tethered_node.is_in_group("anchor") and !tethered_node.is_in_group("lever"):
		if hold_counter >= HOLD_TIME:
			pass
		else:
			tethered_node.get_node("StatusHolder").fling_tethered_node()
		#tethered_node.get_node("StatusHolder").remove_status("tethered")
		#status_holder.remove_status("tethered")
	
	elif tethered_node.is_in_group("anchor"):
		if hold_counter >= HOLD_TIME:
			pass
		else:
			# The player is already transitioning to the grapple state
			status_holder.remove_status("tethered")
			tethered_node.get_node("StatusHolder").remove_status("tethered")
			target.get_node("YarnController").queue_free()
	
	elif tethered_node.is_in_group("lever"):
		tethered_node.get_node("StatusHolder").fling_tethered_node()
		tethered_node.get_node("StatusHolder").remove_status("tethered")
		status_holder.remove_status("tethered")
		target.get_node("YarnController").queue_free()
	
	#StatusEffectsManager.yarn_line2d.queue_free()
	change_state("CanAttack")

func update_guide_arrow(dist, mouse_pos):
	# Define the guide arrow to help the player aim their throw
	if !target.get_node_or_null("AimGuide"):
		guide_arrow = yarn_aim_guide.instantiate()
		target.add_child(guide_arrow)
	
	# Adjust values to not exceed the YARN_LENGTH limit
	if dist > YARN_LENGTH:
		arrow_point = tethered_node.global_position.lerp(mouse_pos, YARN_LENGTH/dist)
		dist = YARN_LENGTH
	else:
		arrow_point = mouse_pos
	
	var selected_node
	
	# Place the arrow head at the mouse position
	guide_arrow.global_position = arrow_point
	# Draw a line from the node to the arrow head
	guide_arrow.get_node("Line2D").points[0] = Vector2(-dist, 0)
	# Rotate the arrow to point at the mouse position
	var realtive_pos = tethered_node.to_local(arrow_point)
	var arrow_rotation = Vector2.ZERO.angle_to_point(realtive_pos)
	guide_arrow.rotation = arrow_rotation
