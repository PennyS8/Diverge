extends Node2D

var scene = preload("res://modules/entities/enemies/shades/shade/melee_shade.tscn")

var strength = 3.0

@onready var playerNoise

#fuzz area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if !playerNoise:
		playerNoise = LevelManager.player.get_node("stressEffect")
	playerNoise.material.set_shader_parameter("band_strength", strength)

func _on_area_2d_body_exited(body: Node2D) -> void:
	playerNoise.material.set_shader_parameter("band_strength", strength - 1.0 )

func _on_spawing_area_body_entered(body: Node2D) -> void:
	var instance : CharacterBody2D = scene.instantiate()
	instance.set_collision_mask_value(2, false)
	get_tree().current_scene.call_deferred("add_child", instance)
	instance.position = Vector2.ZERO
	instance.global_position = global_position
