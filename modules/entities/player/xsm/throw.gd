@tool
extends StateSound

var yarn_aim_guide = preload("res://modules/status_effects/yarn_aim_guide.tscn")
var guide_arrow
var arrow_point

var tethered_node
var selected_node

var hold_counter : float = 0.0
const HOLD_TIME : float = 0.15
var hold : bool

const YARN_LENGTH := 96.0 # 64 + 32

var interupt : bool

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	hold_counter = 0.0
	interupt = false
	hold = false
	
	# Find the targeted tethered node (not the player)
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	tethered_node = tethered_nodes[0]
	if tethered_node.is_in_group("player"):
		tethered_node = tethered_nodes[1]

func _on_update(delta: float) -> void:
	if tethered_node.is_in_group("lever"):
		change_state("Idle")
		return
	
	if !hold and Input.is_action_pressed("throw"):
		hold_counter += delta
		if hold_counter >= HOLD_TIME:
			hold = true
	
	# These vars declared here because they're needed if we grapple an anchor
	var mouse_pos = target.get_global_mouse_position()
	var dist = tethered_node.global_position.distance_to(mouse_pos)
	
	if Input.is_action_just_released("throw"):
		# Find the targeted tethered node (not the player)
		var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
		tethered_node = tethered_nodes[0]
		if tethered_node.is_in_group("player"):
			tethered_node = tethered_nodes[1]
		
		# Only find selected node if "throw" was held down
		if hold:
			selected_node = get_tree().get_first_node_in_group("selected")
		
		# If the player has tethered ONLY an anchor, then grapple the anchor
		if dist > YARN_LENGTH and !selected_node:
			if tethered_node.is_in_group("anchor"):
				if hold:
					pass
				else:
					change_state("Grapple", tethered_node)
					return
		
		# Otherwise exit throw state normally
		change_state("Idle")
		return
	
	# Draw a guide arrow if the "throw" button is being held down
	if hold:
		update_guide_arrow(dist, mouse_pos)
		
	if Input.is_action_just_pressed("recall"):
		interupt = true
		change_state("Recall")

func _before_exit(_args):
	if Input.is_action_pressed("recall"):
		interupt = true

func _on_exit(_args) -> void:
	if guide_arrow: # Remove the guide arrow
		guide_arrow.queue_free()
		guide_arrow = null
	
	if interupt:
		target.remove_tethered_status()
		tethered_node.remove_tethered_status()
		if selected_node:
			selected_node.remove_tethered_status()
		target.get_node_or_null("YarnController").queue_free()
		change_state("CanAttack")
		return
	
	# Check for valid selected node in range to collide with node being thrown
	if selected_node:
		# Check for invalid selected nodes
		var dist = tethered_node.global_position.distance_to(selected_node.global_position)
		if (
			selected_node.is_in_group("lever") or
			tethered_node.is_in_group("lever") or
			dist > YARN_LENGTH or
			!hold
		):
			selected_node.deselect()
			selected_node = null
		
		# Pull the tethered_node and the selected_node toward eachother, if able
		else:
			selected_node.add_tethered_status()
			target.remove_tethered_status()
			target.get_node_or_null("YarnController").queue_free()
			
			selected_node.deselect()
			
			selected_node.pull()
			tethered_node.pull()
			
			selected_node.remove_tethered_status()
			tethered_node.remove_tethered_status()
	
	# Pull the tethered body to the player, or the player to an anchor
	elif !tethered_node.is_in_group("anchor"):
		if hold:
			pass
		elif !interupt:
			tethered_node.fling()
	
	elif tethered_node.is_in_group("anchor"):
		if hold: # Sanity check
			pass
		else:
			# The player is already transitioning to the grapple state
			target.remove_tethered_status()
			tethered_node.remove_tethered_status()
			target.get_node_or_null("YarnController").queue_free()
	
	elif tethered_node.is_in_group("lever"):
		tethered_node.fling()
		target.remove_tethered_status()
		target.get_node_or_null("YarnController").queue_free()
	
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
	
	# Place the arrow head at the mouse position
	guide_arrow.global_position = arrow_point
	# Draw a line from the node to the arrow head
	guide_arrow.get_node("Line2D").points[0] = Vector2(-dist, 0)
	# Rotate the arrow to point at the mouse position
	var realtive_pos = tethered_node.to_local(arrow_point)
	var arrow_rotation = Vector2.ZERO.angle_to_point(realtive_pos)
	guide_arrow.rotation = arrow_rotation
