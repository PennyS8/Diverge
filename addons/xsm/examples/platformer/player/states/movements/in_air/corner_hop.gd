@tool
extends StateAnimation


@export var corner_advance := 20


# FUNCTIONS AVAILABLE TO INHERIT

func _on_update(_delta) -> void:
	var result = target.ray(target.wall_dir, target.BOTTOM, 1.5)
	if result.is_empty():
		target.velocity.x = target.wall_dir * corner_advance
	else:
		target.velocity.y = - target.jump_speed
