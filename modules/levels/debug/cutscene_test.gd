extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if LevelManager.player:
		await LevelManager.player.enter_cutscene(Vector2.ZERO)
		await LevelManager.player.do_walk(Vector2(0, 48))
		await LevelManager.player.do_walk(Vector2(56, 48))
		LevelManager.player.exit_cutscene()
		print("done!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
