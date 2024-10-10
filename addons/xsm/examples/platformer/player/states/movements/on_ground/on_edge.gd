@tool
extends StateAnimation


# FUNCTIONS AVAILABLE TO INHERIT

func _on_enter(_args) -> void:
	target.velocity.x = 0


# func _on_update(_delta) -> void:
# 	if target.velocity.x != 0:
# 		var _st = change_state("Walk")

