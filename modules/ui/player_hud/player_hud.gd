extends CanvasLayer

var hearts : Array[HUDHeart] = []

func _ready() -> void:
	for child in $IngameUI/MarginContainer/HFlowContainer.get_children():
		if child is HUDHeart:
			hearts.append(child)
			

func heart_damage(amount : int):
	var player_health = get_tree().get_first_node_in_group("player").health_component.health
	var player_max_health = get_tree().get_first_node_in_group("player").health_component.max_health
	var max_hearts : int = ceil(player_max_health / 2.0)
	var index = ceil((player_health) / 2.0) - 1
	
	# Sets index back to 0 in the case that it becomes a negative number
	if index < 0:
		index = 0

	hearts[index].update_sprite(amount)

func heart_heal(amount : int):
	pass
	
	
