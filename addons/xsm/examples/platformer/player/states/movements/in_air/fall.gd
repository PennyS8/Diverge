@tool
extends StateAnimation


@export var air_top_margin := 50

# FUNCTIONS TO INHERIT #
func _on_update(_delta):
	if target.velocity.y < 0 and abs(target.velocity.y) < air_top_margin:
		var _st = change_state("FallTop")
