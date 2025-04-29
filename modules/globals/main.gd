extends Node2D

@export var inventory_path : NodePath
func _ready():
	# Deletes 'temp' save folder if it exists
	SaveAndLoad.delete_game_saves()
	LevelManager.main_ready.emit()
	SaveAndLoad.main_ready.emit()
	SaveAndLoad.load_player()
	GameManager.inventory_node = get_node(inventory_path)

func _on_equipment_panel_check_hook() -> void:
	if get_node_or_null("Player"):
		$Player.check_unlock_hook()
