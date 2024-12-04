class_name HUDHeart extends Control

@onready var _animation_player = $AnimationPlayer
var full = true
var empty = false

func update_sprite(animation : String):
	var player_health = get_tree().get_first_node_in_group("player").health_component.health
	
	if animation == "full_damage":
		_animation_player.play("damage_full")
		empty = true
	else:
		_animation_player.play("damage_half")
		full = false
