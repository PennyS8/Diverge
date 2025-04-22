@tool
extends State

@export var ramen_pattern : Array[ItemLike]
var dashing

## Unit: Pixels
@export var dash_distance : float
@export var dash_speed : float

func _on_enter(_args) -> void:
	# Needs to be cleared at the start to reset data from last frame
	target.ai_steering.clear()
	
	if _check_player_inv():
		change_state("RamenSurprised")
	#else:
		#var tween = target.create_tween().set_parallel(true)
		#var end_position = target.global_position + Vector2(randi_range(-24, 24), randi_range(24, 32))
		#tween.tween_property(target, "global_position", end_position, 2.0)
		#tween.chain().tween_callback(target.queue_free)

func _check_player_inv():
	var inv : Inventory = GameManager.inventory_node.inventory
	if inv.count_items(ramen_pattern):
		return true
	else:
		return false
