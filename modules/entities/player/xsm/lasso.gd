@tool
extends StateSound

var yarn_controller = preload("res://modules/status_effects/yarn_controller.tscn")
@onready var yarn_origin = %YarnOrigin
# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var yarn = yarn_controller.instantiate()
	
	# Rotate the yarn projectile toward the mouse
	var mouse_pos = target.get_global_mouse_position()
	var dir = yarn_origin.global_position.direction_to(mouse_pos).normalized()
	yarn.rotation = Vector2.ZERO.angle_to_point(dir)
	yarn.position = yarn_origin.position
	
	target.add_child(yarn)
