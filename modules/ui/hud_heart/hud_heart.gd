class_name HUDHeart extends Control

@onready var _animation_player = $AnimationPlayer

func update_sprite(damage : int):
	var player_health = get_tree().get_first_node_in_group("player").health_component.health
	
	# Player health gets updated before the animation so we need to switch the
	# posistion of the animations to account for it
	if (player_health - damage) % 2 == 0:
		_animation_player.play("damage_full")
	else:
		_animation_player.play("damage_half")
