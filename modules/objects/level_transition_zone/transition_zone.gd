extends Area2D

@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String
@onready var player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#get_tree().change_scene_to_file("res://modules/levels/placeholder_mom_house/placeholder_home.tscn")
		LevelManager.change_level(next_level_path, entrance_name)
		# Heal the player to max
		var healthComponent = player.get_node_or_null("HealthComponent")
		player.health_component.heal(healthComponent.max_health)
