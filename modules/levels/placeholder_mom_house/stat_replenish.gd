extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	print(player.health_component.health)
	player.health_component.health = player.health_component.max_health
	print(player.health_component.health)
