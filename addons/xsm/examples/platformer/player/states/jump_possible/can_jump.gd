@tool
extends State


@export var prejump_time := 0.4

# FUNCTIONS AVAILABLE TO INHERIT
func _on_enter(_args) -> void:
	if has_timer("Prejump"):
		choose_jump()


func _on_update(_delta) -> void:
	if has_timer("PreJump") or Input.is_action_just_pressed("ui_up"):
		choose_jump()


func choose_jump():
	if is_active("OnWall"):
		var _st = change_state("WallJump")
	else:
		var _st = change_state("GroundJump")


func _on_CanPreJump_pre_jumped():
	var _t = add_timer("PreJump", prejump_time)
