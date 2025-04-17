@tool
extends State

@export var ramen_pattern : Array[ItemLike]

## Unit: Pixels
@export var dash_distance : float

@export var dash_speed : float

var dashing
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
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
	var deinv : Inventory = GameManager.inventory_node.inventory
	if deinv.count_items(ramen_pattern):
		return true
	else: return false
