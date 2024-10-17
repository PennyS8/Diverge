@tool
extends State


# has been transfered to the timed property in the inspector
# @export var coyote_time := .1

var origin_state

# FUNCTIONS AVAILABLE TO INHERIT

func _on_enter(from) -> void:
	# has been transfered to the timed property in the inspector
	# var _t = add_timer("CoyoteTime", coyote_time)
	origin_state = from


func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("ui_up"):
		if origin_state == "OnGround":
			var _st1 = change_state("GroundJump")
		elif origin_state == "OnWall":
			var _st2 = change_state("WallJump")
		var _st3 = change_state("CanPreJump")


# has been transfered to the timed property in the inspector			
# func _on_exit(_args):
# 	del_timers()
