extends TetherableBody

@export var num_shades := 12
var shade_packed = preload("res://modules/entities/enemies/shades/shade/melee_shade.tscn")

@onready var sprite = $Display/Sprite2D
func _on_health_component_died() -> void:
	
	var angle_offset = deg_to_rad(360/(num_shades-1))

	for i in range(0, num_shades):
		var shade = shade_packed.instantiate()
		var hurtbox : HurtBoxComponent2D = shade.get_node("Hurtbox")
		hurtbox.call_deferred("set_collision_mask_value", 3, false)
		hurtbox.call_deferred("set_collision_mask_value", 13, true)
		
		call_deferred("add_sibling", shade)
		
		var split_pos = Vector2(cos(angle_offset*i), sin(angle_offset*i))
		split_pos.x += randf_range(-1, 1)
		split_pos.y += randi_range(-1, 1)
		shade.global_position = global_position + split_pos
	$AnimationPlayer.play("attack")

	
func _on_hurt_box_component_2d_hit(_area) -> void:
	$AnimationPlayer.play("hit")
