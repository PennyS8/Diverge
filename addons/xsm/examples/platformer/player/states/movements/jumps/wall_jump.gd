@tool
extends StateAnimation


@export var wall_jump_speed := 320


# FUNCTIONS AVAILABLE TO INHERIT

func _on_enter(_args) -> void:
	target.skin.rotation = - target.wall_dir * PI/2


func jump():
	target.velocity = Vector2(- target.wall_dir * wall_jump_speed, - wall_jump_speed)
	target.velocity = target.velocity.normalized() * wall_jump_speed
	
	var anim_player = get_node_or_null(animation_player)
	if anim_player and anim_player.current_animation_position >= 0.1:
		target.skin.rotation = - target.velocity.angle_to(Vector2.UP)
		target.skin.position = Vector2()


func _on_exit(_args) -> void:
	target.skin.rotation = 0
