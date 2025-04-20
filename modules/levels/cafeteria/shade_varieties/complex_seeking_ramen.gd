@tool
extends State

@export var ramen_pattern : Array[ItemLike]

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	target.velocity = Vector2.ZERO
	target.movement_speed = 60.0

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass
	
func get_nearest_edible_ramen():
	var ramens = get_tree().get_nodes_in_group("edible_ramen")
	
	if ramens == []:
		return null
	
	var nearest_ramen = ramens[0]
	var nearest_distance = target.global_position.distance_squared_to(nearest_ramen.global_position)
	
	# Find the nearest ramen
	for ramen in ramens:
		var distance = target.global_position.distance_squared_to(ramen.global_position)
		if distance < nearest_distance:
			nearest_ramen = ramen
			nearest_distance = distance
	return nearest_ramen
	
# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	target.follow_object = get_nearest_edible_ramen()
	
	if !target.follow_object:
		if _check_player_inv():
			target.follow_object = get_tree().get_first_node_in_group("player")
			change_state("Surprised")
		else:
			change_state("NoMoreRamen")
	else:
		var distance = target.global_position.distance_to(target.follow_object.global_position)
		if distance < 18.0:
			var item : Area2D = target.follow_object.get_node_or_null("Item")
			if item:
				if item.get_collision_mask_value(4):
					target.velocity = Vector2.ZERO
					target.pick_up.emit(target)
					change_state("FoundRamen")
		else:
			var target_position = target.follow_object.global_position
			var displacement = target_position - target.global_position
			
			var target_angle = displacement.angle()
			target.ai_steering.apply_seek(target_angle)


func _check_player_inv():
	var deinv : Inventory = GameManager.inventory_node.inventory
	if deinv.count_items(ramen_pattern):
		return true
	else: return false
