@tool
extends State


# FUNCTIONS AVAILABLE TO INHERIT

func _on_enter(_args) -> void:
	var _st1 = change_state("CanJump")
	var _st2 = change_state("CanDash")

	target.skin.scale.x = - target.wall_dir
	target.skin.position.x = - target.wall_dir * 3
	target.skin.rotation = - target.wall_dir * PI/2


func _on_update(_delta) -> void:
	var dir_out_of_wall := false
	if target.wall_dir < 0 and Input.is_action_just_pressed("ui_right") \
			or target.wall_dir > 0 and Input.is_action_just_pressed("ui_left"):
		dir_out_of_wall = true
	
	if dir_out_of_wall \
			or Input.is_action_pressed("ui_down"):
		target.position.x -= target.wall_dir
		var _st1 = change_state("CoyoteTime", "OnWall")
		var _st2 = change_state("Fall")


func _after_update(_delta) -> void:
	target.velocity = Vector2()


func _on_landed_on_wall():
	var _st = change_state("IdleOnWall")
 

func _on_exit(_args) -> void:
	target.skin.rotation = 0
	target.skin.position = Vector2()
