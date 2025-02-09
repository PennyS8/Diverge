extends Node2D

func _ready():
	# Deletes 'temp' save folder if it exists
	SaveAndLoad.delete_room_saves()
	LevelManager.main_ready.emit()
	SaveAndLoad.main_ready.emit()
