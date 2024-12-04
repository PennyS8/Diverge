extends CanvasLayer

var hearts : Array[HUDHeart] = []

func _ready() -> void:
	for child in $IngameUI/MarginContainer/HFlowContainer.get_children():
		if child is HUDHeart:
			hearts.append(child)
			

func heart_damage(amount : int):
	var player_max_health = get_tree().get_first_node_in_group("player").health_component.max_health
	var max_hearts : int = ceil(player_max_health / 2.0)
	var damage = amount

	for i in range(max_hearts - 1, -1, -1):
		if damage <= 0:
			break
		if hearts[i].empty:
			continue
		
		if (damage >= 2) or (hearts[i].full == false):
			if hearts[i].full == false:
				damage -= 1
			else:
				damage -= 2
			hearts[i].update_sprite("full_damage")
		else:
			hearts[i].update_sprite("half_damage")
			damage = 0

func heart_heal(amount : int):
	pass
