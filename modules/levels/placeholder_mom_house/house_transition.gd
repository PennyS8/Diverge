extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://modules/levels/placeholder_mom_house/placeholder_home.tscn")
