@tool
extends StateAnimation


@export var ground_jump_speed := 320


# FUNCTIONS AVAILABLE TO INHERIT

# func _on_enter(_args) -> void:
	# Commented because it is defined in the inspector as "Anim_on_enter"
	# play("Jump")


func jump():
	target.velocity.y = - ground_jump_speed

	if get_parent().in_air:
		target.skin.rotation = - target.velocity.angle_to(Vector2.UP)
