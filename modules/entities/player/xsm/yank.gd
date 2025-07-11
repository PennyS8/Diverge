@tool
extends StateSound

var hold_counter : float = 0.0
const HOLD_TIME : float = 0.15
var hold : bool

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	hold_counter = 0.0
	hold = false
	
	if %yarn.tethered_body.is_in_group("lever"):
		change_state("Pull")
		return

func _on_update(delta: float) -> void:
	
	if Input.is_action_just_pressed("frog"):
		change_state("Frog")
	
	if %yarn.tethered_body.is_in_group("lever"):
		change_state("Pull")
	
	var mouse_pos = target.get_global_mouse_position()
	var dist = %yarn.tethered_body.global_position.distance_to(mouse_pos)
	
	# Update the guide arrow if the "yank" button is being held down
	if hold:
		%yarn.update_guide_arrow(dist, mouse_pos)
	
	# Initiate the timer to detect holding down the "yank" button
	elif Input.is_action_pressed("yank"):
		hold_counter += delta
		if hold_counter >= HOLD_TIME:
			hold = true
	
	if Input.is_action_just_released("yank"):
		if hold:
			change_state("Connect")
		else:
			change_state("Pull")

func _on_exit(_args) -> void:
	target.get_node_or_null("YarnController").queue_free()
	
	if is_instance_valid(%yarn.guide_arrow): # Remove the guide arrow
		%yarn.guide_arrow.queue_free()
		%yarn.guide_arrow = null
