@tool
extends StateSound


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	var attack_direction = target.global_position.direction_to(get_viewport().get_mouse_position()).normalized()
	
	var component_x = abs(attack_direction.x)
	var component_y = abs(attack_direction.y)
	
	if component_x > component_y:
		attack_direction.y = 0
	
	if component_y > component_x:
		attack_direction.x = 0
	
	attack_direction = attack_direction.snapped(Vector2.ONE)
