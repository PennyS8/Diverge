extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await LevelManager.swap_done
	var inv : Inventory = GameManager.inventory_node.inventory
	inv.clear()
	LevelManager.player.hook_locked = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
