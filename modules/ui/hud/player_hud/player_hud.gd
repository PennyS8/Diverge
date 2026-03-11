extends CanvasLayer

var hearts : Array[HUDHeart] = []

# This is to make it so heal will wait until damage is done
signal hud_update_complete
var updating : bool = false

func _ready() -> void:
	for child in $IngameUI/HBoxContainer/MarginContainer/HFlowContainer.get_children():
		if child is HUDHeart:
			hearts.append(child)

func heart_damage(amount : int):
	var player_max_health = get_tree().get_first_node_in_group("player").health_component.max_health
	
	# Take the # of actual "hearts" we should have by dividing our max health by 2.0
	var max_hearts : int = ceil(player_max_health / 2.0)
	var damage_left = amount

	# Wait for other function to update before we update here
	if updating:
		await hud_update_complete
	
	# mutex lock variable for other heal/damage
	updating = true
	
	for i in range(max_hearts - 1, -1, -1):
		if damage_left <= 0:
			break
		if hearts[i].heart_health == 0:
			continue
		
		damage_left = hearts[i].damage_sprite(damage_left)
		display_hurt_ui()
	
	updating = false
	hud_update_complete.emit()

func heart_heal(amount : int):
	var heal_left = amount

	# Wait for other function to update before we update here
	if updating:
		await hud_update_complete
	
	# mutex lock variable for other heal/damage
	updating = true
	
	for heart in hearts:
		if heal_left <= 0:
			break
		if heart.heart_health == 2:
			continue
		
		heal_left = heart.heal_sprite(heal_left)
	
	updating = false
	hud_update_complete.emit()

func display_hurt_ui():
	get_tree().get_first_node_in_group("player").start_invulnerability_effect()
	var tween = create_tween()
	tween.tween_property($IngameUI/HurtIndicator, "modulate:a", 1.0, 0.3)
	tween.tween_interval(0.3)
	tween.tween_property($IngameUI/HurtIndicator, "modulate:a", 0.0, 0.3)
	
