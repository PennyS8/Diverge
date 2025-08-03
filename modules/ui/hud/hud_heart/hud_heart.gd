class_name HUDHeart extends Control

@onready var _animation_player = $AnimationPlayer
@onready var _sprite = $Sprite2D
var full = true
var empty = false

func damage_sprite(animation : String):
	# Sets the sprite to an empty heart
	if animation == "full_damage":
		_animation_player.play("damage_full")
		empty = true
		full = false
	# Sets the sprite to half a heart
	else:
		_animation_player.play("damage_half")
		full = false
		empty = false

func heal_sprite(animation: String):
	_animation_player.stop()

	# Sets the sprite to a full heart
	if animation == "full_heal":
		_sprite.set_frame(39)
		full = true
		empty = false
	# Sets the sprite to half a heart
	else:
		_sprite.set_frame(41)
		full = false
		empty = false
