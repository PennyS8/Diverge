extends Node2D

func _ready():
	LevelManager.main_ready.emit()
	SaveAndLoad.main_ready.emit()
	SaveAndLoad.delete_room_saves()
