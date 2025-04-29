extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player = get_tree().get_first_node_in_group("player")
		player.health_component.heal(2)
		
		# Once player has been healed, we just remove the area
		queue_free()
