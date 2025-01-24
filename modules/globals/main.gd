extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	LevelManager.main_ready.emit()
