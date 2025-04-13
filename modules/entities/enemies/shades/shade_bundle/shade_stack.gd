extends TetherableBody

@export var shade_healths_stored : Array[int]
var shade_packed = preload("res://modules/entities/enemies/shades/shade/melee_shade.tscn")

@onready var sprite = $Display/Sprite2D

func _on_health_component_died() -> void:
	if shade_healths_stored.is_empty():
		shade_healths_stored.append(10)
		shade_healths_stored.append(10)
	
	var angle_offset = deg_to_rad(360/shade_healths_stored.size())

	for i in range(1, shade_healths_stored.size()+1):
		var shade = shade_packed.instantiate()
		var hurtbox : HurtBoxComponent2D = shade.get_node("Hurtbox")
		hurtbox.call_deferred("set_collision_mask_value", 3, false)
		hurtbox.call_deferred("set_collision_mask_value", 13, true)
		
		call_deferred("add_sibling", shade)
		
		var split_pos = Vector2(cos(angle_offset*i), sin(angle_offset*i))
		shade.set_deferred("global_position", global_position + split_pos)
		shade.get_node("HealthComponent").set_deferred("health", shade_healths_stored[i-1])
	$AnimationPlayer.play("attack")

func _on_hurt_box_component_2d_hit(_area) -> void:
	$AnimationPlayer.play("hit")
	GameManager.hitlag()
