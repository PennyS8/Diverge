extends CanvasLayer

var hearts : Array[HUDHeart] = []

func _ready() -> void:
	for child in $IngameUI/HBoxContainer/MarginContainer/HFlowContainer.get_children():
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
			hearts[i].damage_sprite("full_damage")
			display_hurt_ui()
		else:
			hearts[i].damage_sprite("half_damage")
			damage = 0
			display_hurt_ui()


func heart_heal(amount : int):
	
	var heal = amount

	for heart in hearts:
		if heal <= 0:
			break
		if heart.full:
			continue
		
		if (heal >= 2) and (heart.empty == true):
			heal -= 2
			heart.heal_sprite("full_heal")
		else:
			if heart.empty == false:
				heal -= 1
				heart.heal_sprite("full_heal")
			else:
				heal = 0
				heart.heal_sprite("half_heal")

func display_hurt_ui():
	var tween = create_tween()
	tween.tween_property($IngameUI/HurtIndicator, "modulate:a", 1.0, 0.1)
	tween.tween_interval(0.3)
	tween.tween_property($IngameUI/HurtIndicator, "modulate:a", 0.0, 0.1)
	
