extends Area2D

@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#get_tree().change_scene_to_file("res://modules/levels/placeholder_mom_house/placeholder_home.tscn")
		LevelManager.change_level(next_level_path, entrance_name)
