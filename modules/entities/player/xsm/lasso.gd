@tool
extends StateSound

var yarn_controller = preload("res://modules/status_effects/yarn_controller.tscn")

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var yarn = yarn_controller.instantiate()
	
	# Rotate the yarn projectile toward the mouse
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var dir = target.global_position.direction_to(mouse_pos).normalized()
	yarn.rotation = Vector2.ZERO.angle_to_point(dir)
	yarn.position.y -= 8
	
	target.add_child(yarn)
