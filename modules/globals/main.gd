extends Node2D

@export var inventory_path : NodePath
func _ready():
	# Deletes 'temp' save folder if it exists
	SaveAndLoad.delete_game_saves()
	LevelManager.main_ready.emit()
	SaveAndLoad.main_ready.emit()
	RespawnManager.main_ready.emit()
	# We pass in the current level to prevent player's position being set outside of map
	SaveAndLoad.load_player(LevelManager.current_level.scene_file_path)
	GameManager.inventory_node = get_node(inventory_path)

func _on_equipment_panel_check_hook() -> void:
	if get_node_or_null("Player"):
		$Player.check_unlock_hook()
