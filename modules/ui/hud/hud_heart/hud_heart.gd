class_name HUDHeart extends Control

@onready var _animation_player = $AnimationPlayer
@onready var _sprite = $Sprite2D
var heart_health = 2

func damage_sprite(damage_left : int) -> int:
	flash()
	# Guarentees we will have an empty heart
	if ((damage_left >= 2) or (heart_health == 1)):
		# Empty heart frame
		_sprite.set_frame(54)
		
		damage_left = damage_left - heart_health
		heart_health = 0
	else:
		# Half heart frame
		_sprite.set_frame(41)
		
		damage_left = damage_left - 1
		heart_health = 1
	
	return damage_left

func heal_sprite(heal_left : int) -> int:
	# Guarentees we will have healed to a full heart
	if ((heal_left >= 2) or (heart_health == 1)):
		# Full heart frame
		_sprite.set_frame(39)
		
		# Can't just subtract by heart_health as it could be 0
		if heart_health == 1:
			heal_left = heal_left - 1
		else:
			heal_left = heal_left - 2
		
		heart_health = 2
	else:
		# Half heart frame
		_sprite.set_frame(41)
		
		heal_left = heal_left - 1
		heart_health = 1
	
	return heal_left

func flash():
	var tween : Tween = create_tween()
	tween.tween_property(_sprite, "modulate:v", 1, 0.25).from(15)
