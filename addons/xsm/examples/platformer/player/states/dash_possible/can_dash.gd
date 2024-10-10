@tool
extends State


@export var predash_time := .5


# FUNCTIONS AVAILABLE TO INHERIT
func _on_enter(_args) -> void:
	if has_timer("PreDash"):
		var _st = change_state("Dash")


func _on_update(_delta) -> void:
	if has_timer("PreDash") or Input.is_action_just_pressed("ui_accept"):
		var _st = change_state("Dash")


func _on_CanPreDash_pre_dashed():
	var _t = add_timer("PreDash", predash_time)
