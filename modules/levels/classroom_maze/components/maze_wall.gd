extends Node2D

var scene = preload("res://modules/entities/enemies/shades/complex_shade/complex_shade.tscn")

var strength = 0.1

@onready var playerNoise : Control

var spawned := false

#fuzz area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if !playerNoise:
		playerNoise = LevelManager.player.get_node("stressEffect")
	playerNoise.set_instance_shader_parameter("r_displacement", Vector2(10.0, -10.0))
	playerNoise.set_instance_shader_parameter("g_displacement", Vector2(-10.0, -10.0))
	playerNoise.set_instance_shader_parameter("b_displacement", Vector2(0, 10.0))
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	playerNoise.set_instance_shader_parameter("r_displacement", Vector2(6.0, -6.0))
	playerNoise.set_instance_shader_parameter("g_displacement", Vector2(-6.0, -6.0))
	playerNoise.set_instance_shader_parameter("b_displacement", Vector2(0, 6.0))
func _on_spawing_area_body_entered(body: Node2D) -> void:
	if !spawned:
		var instance : CharacterBody2D = scene.instantiate()
		instance.set_collision_mask_value(2, false)
		get_tree().current_scene.call_deferred("add_child", instance)
		
		instance.position = Vector2.ZERO
		instance.global_position = global_position
		spawned = true
	
