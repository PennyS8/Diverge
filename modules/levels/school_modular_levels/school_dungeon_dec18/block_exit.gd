extends StaticBody2D

var player

# Clears exit blocker if player has completed library dialogue and obtained quest item.
func _on_exit_unblocker_body_entered(body: Node2D) -> void:
	player = LevelManager.player
	
	if player.dialogue_tracker["library"]:
		queue_free()
