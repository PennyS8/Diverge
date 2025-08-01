extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await LevelManager.swap_done
	DirAccess.remove_absolute("user://player_inventory")
	LevelManager.player.hook_locked = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
